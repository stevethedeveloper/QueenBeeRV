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

    override func loadView() {
        view = UIView()
        
        playerView = YTPlayerView()
        playerView.load(withVideoId: "0frhAtWCoy8")
//        playerView.load(withPlaylistId: "PLHjzGLpw8j9HL4cQmGuKRelglepviECd0")
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        
        playerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        playerView.bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor, constant: 20).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Videos"
    }
    
}
