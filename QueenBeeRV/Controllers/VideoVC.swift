//
//  VideoVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/24/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoVC: UIViewController, YTPlayerViewDelegate {
    private let viewModel = VideoViewModel()
    private var playerView: YTPlayerView!
    private let headerViewIdentifier = "TableViewHeaderView"
    private var tableView: UITableView?
    private var loadingView = UIImageView()

    override func loadView() {
        let view = UIView()
        self.view = view
        view.backgroundColor = .systemBackground
        viewModel.fetchPlaylists()
        viewModel.fetchLatestVideos()
        setupPlayerView()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        configureTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Videos"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        displayVideo(viewModel.promoVideoId)
        
        viewModel.data.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }

        viewModel.onErrorHandling = { error in
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "An error occured", message: error, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
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
            tableView.register(VideoTableSectionHeader.self, forHeaderFooterViewReuseIdentifier: headerViewIdentifier)

            tableView.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableFooterView = nil

            let constraints = [
                tableView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func setupPlayerView() {
        playerView = YTPlayerView()
        playerView.delegate = self
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        
        let constraints = [
            playerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
        
        loadingView.image = UIImage(named: "loading")
        loadingView.contentMode = .scaleAspectFit
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .systemBackground
        loadingView.layer.zPosition = 1
        loadingView.isHidden = false
        playerView.addSubview(loadingView)
        let loadingViewConstraints = [
            loadingView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(loadingViewConstraints)
    }
    
    func displayVideo(_ videoId: String) {
        playerView.load(withVideoId: videoId, playerVars: ["playsinline": 1, "modestbranding": 1, "rel": 0])
        return
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loadingView.isHidden = true
    }

    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the videos; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func viewAllVideos() {
        let vc = PlaylistVC()
        vc.viewModel.playlistID = viewModel.youtubeAllVideosPlaylistID
        vc.viewModel.playlistName = "All Videos"
        vc.viewModel.selectedVideo.value = viewModel.latestVideos?.items[0]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Data delegate and datasource functions
extension VideoVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.data.value[section].sectionName == viewModel.playlistSectionTitle {
            return viewModel.data.value[section].playlists?.count ?? 0
        } else if viewModel.data.value[section].sectionName == viewModel.videoSectionTitle {
            return viewModel.data.value[section].videos?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.data.value[indexPath.section].sectionName == viewModel.videoSectionTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            cell.separatorInset = .zero
            let itemsInSection = viewModel.data.value[indexPath.section].videos
            guard let video = itemsInSection?[indexPath.row] else { return UITableViewCell() }
            cell.set(video: video)
//            cell.layer.borderColor = UIColor.systemGray6.cgColor
//            cell.layer.borderWidth = 1
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        } else if viewModel.data.value[indexPath.section].sectionName == viewModel.playlistSectionTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            cell.separatorInset = .zero
            let itemsInSection = viewModel.data.value[indexPath.section].playlists
            guard let playlist = itemsInSection?[indexPath.row] else { return UITableViewCell() }
            cell.set(playlist: playlist)
//            cell.layer.borderColor = UIColor.systemGray6.cgColor
//            cell.layer.borderWidth = 1
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier) as? VideoTableSectionHeader
        header?.labelText = viewModel.data.value[section].sectionName ?? ""
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.data.value[section].sectionName == viewModel.videoSectionTitle {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard viewModel.data.value[section].sectionName == viewModel.videoSectionTitle else { return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
                
        let button = UIButton(type: .custom, primaryAction: UIAction(title: "View All Videos", handler: { _ in
            let vc = PlaylistVC()
            vc.viewModel.playlistID = self.viewModel.youtubeAllVideosPlaylistID
            vc.viewModel.playlistName = "All Videos"
            vc.viewModel.selectedVideo.value = self.viewModel.latestVideos?.items[0]
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        button.center = footerView.center
        button.setTitle("View All Videos", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10.0
        
        footerView.addSubview(button)
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlaylistVC()

        if viewModel.data.value[indexPath.section].sectionName == viewModel.videoSectionTitle {
            vc.viewModel.playlistID = viewModel.youtubeAllVideosPlaylistID
            vc.viewModel.playlistName = "All Videos"
            vc.viewModel.selectedVideo.value = viewModel.latestVideos?.items[indexPath.row]
        } else if viewModel.data.value[indexPath.section].sectionName == viewModel.playlistSectionTitle {
            vc.viewModel.playlistID = viewModel.allPlaylists?.items[indexPath.row].id
            vc.viewModel.playlistName = viewModel.allPlaylists?.items[indexPath.row].title
        } else {
            return
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}
