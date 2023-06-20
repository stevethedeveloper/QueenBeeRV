//
//  VideoVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/24/23.
//

import UIKit
import YouTubeiOSPlayerHelper
import SDWebImage



class VideoVC: UIViewController {
    var playerView: YTPlayerView!
    let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    let youtubeChannelID = Bundle.main.infoDictionary?["YOUTUBE_CHANNEL_ID"] as? String
    let youtubeAllVideosPlaylistID = Bundle.main.infoDictionary?["YOUTUBE_ALL_VIDEOS_PLAYLIST_ID"] as? String

    let headerViewIdentifier = "TableViewHeaderView"
    
    var tableView: UITableView?
    
    
    var latestVideos: Videos?
    var allPlaylists: Playlists?
    
    
    var data = [LatestVideos]()
    
    let promoVideoId: String = "0frhAtWCoy8"
    
    let placeholderImage = UIImage(named: "placeholder")
    
    let playlistSectionTitle = "Playlists"
    let videoSectionTitle = "Latest Videos"
    
    
    override func loadView() {
        // Set up root view
        view = UIView()
        view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Videos"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupPlayerView()
        displayVideo(promoVideoId)
        
        self.tableView = UITableView(frame: view.bounds, style: .grouped)
        configureTableView()
        fetchPlaylists()
        fetchLatestVideos()
    }
    
    func configureTableView() {
        if let tableView = tableView {
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 80
            tableView.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
            tableView.register(VideoTableSectionHeader.self, forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
            tableView.translatesAutoresizingMaskIntoConstraints                          = false
            tableView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 10).isActive    = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10).isActive     = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive   = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive       = true
        }
    }
    
    func setupPlayerView() {
        playerView = YTPlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        
        playerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func displayVideo(_ videoId: String) {
        playerView.load(withVideoId: videoId, playerVars: ["playsinline": 1])
        return
    }
    
    func fetchLatestVideos() {
        let url: URL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(youtubeAllVideosPlaylistID ?? "")&key=\(youtubeKey ?? "")&maxResults=4")!
        
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        // TODO: implement etag
        //        request.setValue("94GJ_J4sdWd_UmWSFt7hnr1Zn_g", forHTTPHeaderField: "If-None-Match")
        //        request.allHTTPHeaderFields?["If-None-Match"] = "4072u9p5TkOOjeUoWj1hoDIN3sI"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            guard let data = data else { return }
            self.parseVideos(json: data)
            DispatchQueue.main.async {
                if let allVideos = self.latestVideos?.items {
                    if allVideos.count > 0 {
                        // add this at any position and playlists at position 0, will throw error if trying to add to position 1 and array is empty
                        self.data.append(LatestVideos.init(sectionName: self.videoSectionTitle, videos: allVideos))
                        self.tableView?.reloadData()
                        //                        self.displayVideo(allVideos[0])
                    }
                }
            }
        }.resume()
    }
    
    func parseVideos(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let videoDecoded = try decoder.decode(Videos.self, from: json)
            self.latestVideos = videoDecoded.items.count > 0 ? videoDecoded : nil
        } catch {
            //            print(error)
            showError()
        }
        
    }
    
    func fetchPlaylists() {
        let url: URL = URL(string: "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=\(youtubeChannelID ?? "")&key=\(youtubeKey ?? "")")!
        
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        // TODO: implement etag
        //        request.setValue("94GJ_J4sdWd_UmWSFt7hnr1Zn_g", forHTTPHeaderField: "If-None-Match")
        //        request.allHTTPHeaderFields?["If-None-Match"] = "4072u9p5TkOOjeUoWj1hoDIN3sI"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            guard let data = data else { return }
            self.parsePlaylists(json: data)
            DispatchQueue.main.async {
                if let allPlaylists = self.allPlaylists?.items {
                    if allPlaylists.count > 0 {
                        // always add this to position 0 so it comes first
                        self.data.insert(LatestVideos.init(sectionName: self.playlistSectionTitle, playlists: allPlaylists), at: 0)
                        self.tableView?.reloadData()
                    }
                }
            }
        }.resume()
        
    }
    
    func parsePlaylists(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let playlistsDecoded = try decoder.decode(Playlists.self, from: json)
            self.allPlaylists = playlistsDecoded.items.count > 0 ? playlistsDecoded : nil
        } catch {
            //            print(error)
            showError()
        }
        
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the videos; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @objc func sectionHeaderTapped() {
        print(data)
    }
    
}

// MARK: Data delegate and datasource functions
extension VideoVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[section].sectionName == playlistSectionTitle {
            return data[section].playlists?.count ?? 0
        } else if data[section].sectionName == videoSectionTitle {
            return data[section].videos?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data[indexPath.section].sectionName == videoSectionTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            let itemsInSection = data[indexPath.section].videos
            guard let video = itemsInSection?[indexPath.row] else { return UITableViewCell() }
            cell.set(video: video)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        } else if data[indexPath.section].sectionName == playlistSectionTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            let itemsInSection = data[indexPath.section].playlists
            guard let playlist = itemsInSection?[indexPath.row] else { return UITableViewCell() }
            cell.set(playlist: playlist)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier) as? VideoTableSectionHeader
        header?.labelText = data[section].sectionName ?? ""
        header?.button.addTarget(self, action: #selector(sectionHeaderTapped), for: .touchUpInside)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if data[section].sectionName == videoSectionTitle {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard data[section].sectionName == videoSectionTitle else { return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        button.center = footerView.center
        button.setTitle("View All Videos", for: .normal)
        button.addTarget(self, action: #selector(viewAllVideos), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10.0
        footerView.addSubview(button)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    @objc func viewAllVideos() {
        let vc = PlaylistVC()
        vc.playlist = youtubeAllVideosPlaylistID
        navigationController?.pushViewController(vc, animated: true)
    }
}
