//
//  VideoListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class PlaylistVC: UIViewController, YTPlayerViewDelegate {
    let viewModel = PlaylistViewModel()
    private var playerView: YTPlayerView!
    var tableView: UITableView?
    var playlistLabel: UILabel!
    private var loadingView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()

    override func loadView() {
        let view = UIView()
        self.view = view
        view.backgroundColor = .systemBackground
        
        setupPlayerView()
        configurePlaylistLabel()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        configureTableView()
        viewModel.fetchPlaylist()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)
        
        viewModel.videos.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
        
        viewModel.selectedVideo.bind { [weak self] selectedVideo in
            self?.displayVideo(selectedVideo)
        }

        viewModel.onErrorHandling = { error in
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "An error occured", message: error, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        }
    }
        
    func setupPlayerView() {
        playerView = YTPlayerView()
        playerView.delegate = self
        view.addSubview(playerView)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            playerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            playerView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
        
        loadingView.image = UIImage(named: "loading")
        loadingView.contentMode = .scaleAspectFit
        loadingView.backgroundColor = .systemBackground
        loadingView.layer.zPosition = 1
        loadingView.isHidden = false
        playerView.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let loadingViewConstraints = [
            loadingView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            loadingView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(loadingViewConstraints)
    }

    func configurePlaylistLabel() {
        playlistLabel = UILabel(frame: view.bounds)
        if let playlistLabel = playlistLabel {
            view.addSubview(playlistLabel)
            playlistLabel.text = viewModel.playlistName

            playlistLabel.textColor = UIColor(named: "AccentColor")
            playlistLabel.font = UIFont.systemFont(ofSize: 24)
            playlistLabel.numberOfLines = 0
            playlistLabel.adjustsFontSizeToFitWidth = true
            playlistLabel.textAlignment = .left

            playlistLabel.translatesAutoresizingMaskIntoConstraints = false
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
            tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identifier)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableFooterView = nil

            let constraints = [
                tableView.topAnchor.constraint(equalTo: playlistLabel.bottomAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }

    func displayVideo(_ video: Video?) {
        if let video = video {
            playerView.load(withVideoId: video.videoId, playerVars: ["playsinline": 1, "autoplay": 1, "modestbranding": 1, "rel": 0])
            tableView?.reloadData()
        }
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
}

// MARK: Data delegate and datasource functions
extension PlaylistVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.videos.value.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier) as! VideoCell
            cell.separatorInset = .zero
            cell.reset()
            let video = viewModel.videos.value[indexPath.row]
            let isNowPlaying = video.videoId == viewModel.selectedVideo.value?.videoId ? true : false
            cell.set(video: video, isNowPlaying: isNowPlaying)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedVideo.value = viewModel.videos.value[indexPath.row]
        loadingView.isHidden = false
    }
        
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        activityIndicator.startAnimating()
        footerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 55
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            tableView?.footerView(forSection: 0)?.isHidden = false
            viewModel.loadMoreVideos()
            if !viewModel.isLoading {
                activityIndicator.stopAnimating()
                tableView?.footerView(forSection: 0)?.isHidden = true
            }
        }
    }
}
