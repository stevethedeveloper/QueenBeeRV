//
//  VideoListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class PlaylistVC: UIViewController {
    let viewModel = PlaylistViewModel()
    private var playerView: YTPlayerView!

    var tableView: UITableView?
    
    var playlistLabel: UILabel!
    
    
    override func loadView() {
        let view = UIView()
        self.view = view
        view.backgroundColor = .systemBackground
        setupPlayerView()
        configurePlaylistLabel()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        configureTableView()
        viewModel.fetchPlaylist()
        tableView?.register(LoadingCell.self, forCellReuseIdentifier: "loadingCellId")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Playlist"

        navigationController?.navigationBar.prefersLargeTitles = false
        
        viewModel.videos.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
        
        viewModel.selectedVideo.bind { [weak self] selectedVideo in
            self?.displayVideo(selectedVideo)
        }

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
            playlistLabel.text = viewModel.playlistName
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

    func displayVideo(_ video: Video?) {
        if let video = video {
            playerView.load(withVideoId: video.videoId, playerVars: ["playsinline": 1, "autoplay": 1, "modestbranding": 1, "rel": 0])
//            viewModel.selectedVideo.value = video
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
            return viewModel.videos.value.count
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
            if viewModel.isLoading {
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
            let video = viewModel.videos.value[indexPath.row]
            let isNowPlaying = video.videoId == viewModel.selectedVideo.value?.videoId ? true : false
            cell.set(video: video, isNowPlaying: isNowPlaying)
//            cell.layer.borderColor = UIColor.systemGray.cgColor
//            cell.layer.borderWidth = 1
            return cell
        } else {
            guard viewModel.playlist?.nextPageToken != nil else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayVideo(viewModel.videos.value[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.playlist?.items.count ?? 0) - 10, !viewModel.isLoading {
            viewModel.loadMoreVideos()
        }
    }
}
