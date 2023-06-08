//
//  VideoListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import UIKit

class VideoListVC: UIViewController {
    let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPlaylists()
    }
    
    func fetchPlaylists() {
        let url: URL = URL(string: "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCyX7EwK1gp-ttAny5j3VmPg&key=\(youtubeKey ?? "")")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { print(error) }
            guard let data = data else { return }
            
            print(data)
        }.resume()
    }
    
}
