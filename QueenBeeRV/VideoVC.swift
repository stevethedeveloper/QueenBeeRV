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
    
    override func loadView() {
        view = UIView()
        
        playerView = YTPlayerView()
        
        //        playerView.load(withVideoId: "0frhAtWCoy8")
        playerView.load(withPlaylistId: "PLHjzGLpw8j9HL4cQmGuKRelglepviECd0", playerVars: ["playsinline": 0])
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        
        view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true

        playerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        playerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        view.backgroundColor = .white
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Videos"

        let urlString: String
        // get all playlists
//        urlString = "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCyX7EwK1gp-ttAny5j3VmPg&key=AIzaSyDa7ztQFUTcUpSKDUF8bg6PlN9q2plsLR8"
        // get videos from playlist
        
        // this gets the latest video, the playlist id is the same as the channel id only starting with UU instead of UC
        // https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UUyX7EwK1gp-ttAny5j3VmPg&key=AIzaSyDa7ztQFUTcUpSKDUF8bg6PlN9q2plsLR8&maxResults=1
        
        print(youtubeKey!)
        urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PLHjzGLpw8j9HL4cQmGuKRelglepviECd0&key=\(youtubeKey ?? "")&maxResults=55"
print(urlString)
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    //self.parse(json: data)
                    print(String(data: data, encoding: .utf8))
                    return
                }
            }
            
//            self.showError()
        }
    }
    
}
