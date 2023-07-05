//
//  VideoListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class PlaylistVC: UIViewController {
    var playerView: YTPlayerView!
    let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    let youtubeChannelID = Bundle.main.infoDictionary?["YOUTUBE_CHANNEL_ID"] as? String
    let youtubeAllVideosPlaylistID = Bundle.main.infoDictionary?["YOUTUBE_ALL_VIDEOS_PLAYLIST_ID"] as? String

    var playlistID: String?
    var playlistName: String?
    var selectedVideo: Video?

    var playlist: Videos?
    var videos = [Video]()

    var tableView: UITableView?
    
    var playlistLabel: UILabel!
    
    var isLoading = false
    
    override func loadView() {
        let view = UIView()
        self.view = view
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Playlist"

        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupPlayerView()

        configurePlaylistLabel()

        tableView = UITableView(frame: view.bounds, style: .grouped)

        configureTableView()
        fetchPlaylist()
                
        tableView?.register(LoadingCell.self, forCellReuseIdentifier: "loadingCellId")
                
        displayVideo(selectedVideo)
    }
    
    func setupPlayerView() {
        playerView = YTPlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        
        let constraints = [
            playerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configurePlaylistLabel() {
        playlistLabel = UILabel(frame: view.bounds)
        if let playlistLabel = playlistLabel {
            view.addSubview(playlistLabel)
            playlistLabel.text = playlistName
            playlistLabel.translatesAutoresizingMaskIntoConstraints = false

            
            playlistLabel.textColor = UIColor(named: "AccentColor")
            playlistLabel.font = UIFont.systemFont(ofSize: 24)
            playlistLabel.numberOfLines = 0
            playlistLabel.adjustsFontSizeToFitWidth = true
            playlistLabel.textAlignment = .left

            
            let constraints = [
                playlistLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 10),
                playlistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                playlistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
                playlistLabel.heightAnchor.constraint(equalToConstant: 70)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }


    func configureTableView() {
        if let tableView = tableView {
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 80
            tableView.separatorColor = .systemGray
            tableView.separatorStyle = .singleLine
            tableView.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableFooterView = nil

            let constraints = [
                tableView.topAnchor.constraint(equalTo: playlistLabel.bottomAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }

    func fetchPlaylist(nextPageToken: String? = nil) {
        var loadingMore: Bool = false
        var urlString: String
        if let token = nextPageToken {
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10&pageToken=\(token)"
            loadingMore = true
        } else {
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10"
        }
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        // TODO: implement etag
        //        request.setValue("94GJ_J4sdWd_UmWSFt7hnr1Zn_g", forHTTPHeaderField: "If-None-Match")
        //        request.allHTTPHeaderFields?["If-None-Match"] = "4072u9p5TkOOjeUoWj1hoDIN3sI"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            guard let data = data else { return }
            self.parseVideos(json: data, loadingMore: loadingMore)
            DispatchQueue.main.async {
                if self.videos.count > 0 {
                    self.tableView?.reloadData()
                    if self.selectedVideo == nil {
                        self.selectedVideo = self.videos[0]
                        self.displayVideo(self.selectedVideo)
                    }
                }
            }
        }.resume()
    }
    
    func loadMoreVideos() {
        guard playlist?.nextPageToken != nil else {
            isLoading = false
            return
        }
        
        if !isLoading {
            isLoading = true
            fetchPlaylist(nextPageToken: playlist?.nextPageToken)
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    func parseVideos(json: Data, loadingMore: Bool = false) {
        let decoder = JSONDecoder()
        do {
            let videoDecoded = try decoder.decode(Videos.self, from: json)
            if loadingMore {
                playlist?.etag = videoDecoded.etag
                playlist?.nextPageToken = videoDecoded.nextPageToken
                videos.append(contentsOf: videoDecoded.items)
            } else {
                playlist = videoDecoded.items.count > 0 ? videoDecoded : nil
                videos = videoDecoded.items
            }
            videos.removeAll(where: {$0.title.contains("Private")})
        } catch {
            showError()
        }
    }

    func displayVideo(_ video: Video?) {
        if let video = video {
            playerView.load(withVideoId: video.videoId, playerVars: ["playsinline": 1, "autoplay": 1, "modestbranding": 1, "rel": 0])
            selectedVideo = video
            tableView?.reloadData()
        }
        return
    }

    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the videos; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }    
}

// MARK: Data delegate and datasource functions
extension PlaylistVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return videos.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            if isLoading {
                return 55
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            cell.separatorInset = .zero
            cell.reset()
            let video = videos[indexPath.row]
            let isNowPlaying = video.videoId == selectedVideo?.videoId ? true : false
            cell.set(video: video, isNowPlaying: isNowPlaying)
//            cell.layer.borderColor = UIColor.systemGray.cgColor
//            cell.layer.borderWidth = 1
            return cell
        } else {
            guard playlist?.nextPageToken != nil else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayVideo(videos[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (playlist?.items.count ?? 0) - 10, !isLoading {
            loadMoreVideos()
        }
    }
}
