//
//  VideoVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/24/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoVC: UIViewController {
    private let viewModel = VideoViewModel()
    private var tableView: UITableView?
    private var loadingView = UIImageView()

    override func loadView() {
        let view = UIView()
        self.view = view
        view.backgroundColor = .systemBackground
        viewModel.fetchPlaylists()
        viewModel.fetchLatestVideos()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        configureTableView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "Videos"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)
        
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
    
    private func configureTableView() {
        if let tableView = tableView {
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorColor = .systemGray
            tableView.separatorStyle = .singleLine
            tableView.register(VideoTableSectionHeader.self, forHeaderFooterViewReuseIdentifier: VideoTableSectionHeader.identifier)

            tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identifier)
            tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableFooterView = nil

            let constraints = [
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loadingView.isHidden = true
    }
    
    private func viewAllVideos() {
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
        if viewModel.data.value[section].sectionName == VideoTableSectionTitle.playlistSectionTitle.rawValue {
            return 1
        } else if viewModel.data.value[section].sectionName == VideoTableSectionTitle.videoSectionTitle.rawValue {
            return viewModel.data.value[section].videos?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.data.value[indexPath.section].sectionName == VideoTableSectionTitle.videoSectionTitle.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier) as! VideoCell
            cell.separatorInset = .zero
            let itemsInSection = viewModel.data.value[indexPath.section].videos
            guard let video = itemsInSection?[indexPath.row] else { return UITableViewCell() }
            cell.set(video: video)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        } else if viewModel.data.value[indexPath.section].sectionName == VideoTableSectionTitle.playlistSectionTitle.rawValue {

            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
            cell.separatorInset = .zero
            guard let itemsInSection = viewModel.data.value[indexPath.section].playlists else { return UITableViewCell() }
            cell.configure(with: itemsInSection)
            cell.parent = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: VideoTableSectionHeader.identifier) as? VideoTableSectionHeader
        header?.labelText = viewModel.data.value[section].sectionName ?? ""
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.data.value[section].sectionName == VideoTableSectionTitle.videoSectionTitle.rawValue {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard viewModel.data.value[section].sectionName == VideoTableSectionTitle.videoSectionTitle.rawValue else { return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        footerView.backgroundColor = .systemBackground
        
        let button = UIButton(type: .custom, primaryAction: UIAction(title: "View More", handler: { _ in
            let vc = PlaylistVC()
            vc.viewModel.playlistID = self.viewModel.youtubeAllVideosPlaylistID
            vc.viewModel.playlistName = "All Videos"
            vc.viewModel.selectedVideo.value = self.viewModel.latestVideos?.items[0]
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        button.center = footerView.center
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10.0
        
        footerView.addSubview(button)
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlaylistVC()

        if viewModel.data.value[indexPath.section].sectionName == VideoTableSectionTitle.videoSectionTitle.rawValue {
            vc.viewModel.playlistID = viewModel.youtubeAllVideosPlaylistID
            vc.viewModel.playlistName = "All Videos"
            vc.viewModel.selectedVideo.value = viewModel.latestVideos?.items[indexPath.row]
        } else {
            return
        }

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        }
        return 100
    }
}
