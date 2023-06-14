//
//  VideoVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/24/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoVC: UIViewController {
    var playerView: YTPlayerView!
    let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    var latestVideo: Video?
    
    override func loadView() {
        view = UIView()
        setupRootView()
        setupPlayerView()
        fetchLatestVideo()
    }

    func setupRootView() {
        view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        //        view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Videos"

        navigationController?.navigationBar.prefersLargeTitles = false

//        let urlString: String
        // get all playlists
//        urlString = "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCyX7EwK1gp-ttAny5j3VmPg&key=AIzaSyDa7ztQFUTcUpSKDUF8bg6PlN9q2plsLR8"
        // get videos from playlist
        
        // this gets the latest video, the playlist id is the same as the channel id only starting with UU instead of UC
        // https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UUyX7EwK1gp-ttAny5j3VmPg&key=AIzaSyDa7ztQFUTcUpSKDUF8bg6PlN9q2plsLR8&maxResults=1
        
//        print(youtubeKey!)
//            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UUyX7EwK1gp-ttAny5j3VmPg&key=AIzaSyDa7ztQFUTcUpSKDUF8bg6PlN9q2plsLR8&maxResults=1"
//        urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PLHjzGLpw8j9HL4cQmGuKRelglepviECd0&key=\(youtubeKey ?? "")&maxResults=55"
//print(urlString)
//        DispatchQueue.global(qos: .userInitiated).async {
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url) {
//                    //self.parse(json: data)
////                    print(String(data: data, encoding: .utf8))
//                    return
//                }
//            }
//
////            self.showError()
//        }
        

    }
    
    
    func setupPlayerView() {
        playerView = YTPlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
                    
        playerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        //        playerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func displayVideo(_ selectedVideo: Video?) {
        if let selectedVideo = selectedVideo {
            playerView.load(withVideoId: selectedVideo.videoId, playerVars: ["playsinline": 1])
        }
        
        return
    }
    
    func fetchLatestVideo() {
        let url: URL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UUyX7EwK1gp-ttAny5j3VmPg&key=\(youtubeKey ?? "")&maxResults=1")!

        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
// TODO: implement etag
//        request.setValue("94GJ_J4sdWd_UmWSFt7hnr1Zn_g", forHTTPHeaderField: "If-None-Match")
//        request.allHTTPHeaderFields?["If-None-Match"] = "4072u9p5TkOOjeUoWj1hoDIN3sI"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            guard let data = data else { return }
            self.parseVideo(json: data)
//            print(self.latestVideo)
            DispatchQueue.main.async {
                self.displayVideo(self.latestVideo)
            }
        }.resume()

    }

    func parseVideo(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let videoDecoded = try decoder.decode(Videos.self, from: json)
            self.latestVideo = videoDecoded.items.count > 0 ? videoDecoded.items[0] : nil
//            print("slv \(self.latestVideo)")
//            DispatchQueue.main.async {
//                self.collectionView?.reloadData()
//            }
        } catch {
            print(error)
//            showError()
        }
        
    }

    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the videos; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

}
