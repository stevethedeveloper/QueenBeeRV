//
//  VideoListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import UIKit

class VideoListVC: UIViewController {
    let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    var playlists: Playlists?

    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchPlaylists()
    }
    
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
               layout.itemSize = CGSize(width: 60, height: 60)
               
               collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        view.addSubview(collectionView ?? UICollectionView())
        collectionView?.register(VideoCollectionCell.self, forCellWithReuseIdentifier: "PlaylistCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
//        collectionView.rowHeight = 100
        collectionView?.pin(to: view)
    }

    
    func fetchPlaylists() {
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
            let playlistsDecoded = try decoder.decode(Playlists.self, from: json)
            playlists = playlistsDecoded
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
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
extension VideoListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCell", for: indexPath) as! VideoCollectionCell
        let playlist = playlists?.items[indexPath.row]
//        cell.set(playlist: playlist)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlists?.items.count ?? 0
    }
        
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = BlogPostVC()
////        vc.modalPresentationStyle = .fullScreen
//        vc.currentWebsite = blogPosts[indexPath.row].url
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
