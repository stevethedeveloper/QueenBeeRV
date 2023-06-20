//
//  VideoListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import UIKit

class PlaylistVC: UIViewController {
    let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    var playlist: String?
    var selectedVideo: Video?
    
    var tableView: UITableView?

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        title = "All Videos"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPlaylist()
    }
    
    
    func fetchPlaylist() {
        let url: URL = URL(string: "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCyX7EwK1gp-ttAny5j3VmPg&key=\(youtubeKey ?? "")")!

        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
// TODO: implement etag
//        request.setValue("94GJ_J4sdWd_UmWSFt7hnr1Zn_g", forHTTPHeaderField: "If-None-Match")
//        request.allHTTPHeaderFields?["If-None-Match"] = "4072u9p5TkOOjeUoWj1hoDIN3sI"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            
            
            
            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("status \(httpResponse.statusCode)")
//                print(httpResponse.allHeaderFields)
//                
//            }
            
            
            
            
            
            guard let data = data else { return }
            self.parse(json: data)
        }.resume()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
//        if let jsonPlaylists = try? decoder.decode(Playlists.self, from: json) {
//            playlists = jsonPlaylists.items
////            DispatchQueue.main.async {
////                self.tableView.reloadData()
////            }
//            print(playlists)
//        }
        
        do {
            let playlistsDecoded = try decoder.decode(Playlist.self, from: json)
//            playlist = playlistsDecoded
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
//            print(playlists ?? Playlists.self)
        } catch {
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

}

// MARK: Data delegate and datasource functions
extension PlaylistVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
