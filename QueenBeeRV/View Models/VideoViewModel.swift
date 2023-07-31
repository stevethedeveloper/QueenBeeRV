//
//  VideoViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/7/23.
//

import Foundation
import UIKit.UIImage

enum VideoTableSectionTitle: String {
    case playlistSectionTitle = "Playlists"
    case videoSectionTitle = "All Videos"
}

public class VideoViewModel {
    var onErrorHandling: ((String) -> Void)?
    private let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    private let youtubeChannelID = Bundle.main.infoDictionary?["YOUTUBE_CHANNEL_ID"] as? String
    let youtubeAllVideosPlaylistID = Bundle.main.infoDictionary?["YOUTUBE_ALL_VIDEOS_PLAYLIST_ID"] as? String

    var latestVideos: Videos?
    var allPlaylists: Playlists?
        
    var data: Observable<[LatestVideos]> = Observable([])
    
    let promoVideoId: String = "0frhAtWCoy8"
    
    let placeholderImage = UIImage(named: "placeholder")

    func fetchLatestVideos() {
        let url: URL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(youtubeAllVideosPlaylistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10")!
        
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        // TODO: implement etag
        //        request.setValue("94GJ_J4sdWd_UmWSFt7hnr1Zn_g", forHTTPHeaderField: "If-None-Match")
        //        request.allHTTPHeaderFields?["If-None-Match"] = "4072u9p5TkOOjeUoWj1hoDIN3sI"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                self.onErrorHandling?("Could not retrieve videos.  Please check your connection and try again.")
            }
            guard let data = data else { return }
            self.parseVideos(json: data)
            DispatchQueue.main.async {
                if let allVideos = self.latestVideos?.items {
                    if allVideos.count > 0 {
                        // add this at any position and playlists at position 0, will throw error if trying to add to position 1 and array is empty
                        self.data.value.append(LatestVideos.init(sectionName: VideoTableSectionTitle.videoSectionTitle.rawValue, videos: allVideos))
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
            self.onErrorHandling?("Could not retrieve videos.  Please check your connection and try again.")
//            showError()
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
            if let error = error {
                print(error)
                self.onErrorHandling?("Could not retrieve playlists.  Please check your connection and try again.")
            }
            guard let data = data else { return }
            self.parsePlaylists(json: data)
            DispatchQueue.main.async {
                if let allPlaylists = self.allPlaylists?.items {
                    if allPlaylists.count > 0 {
                        // always add this to position 0 so it comes first
                        self.data.value.insert(LatestVideos.init(sectionName: VideoTableSectionTitle.playlistSectionTitle.rawValue, playlists: allPlaylists), at: 0)
//                        self.tableView?.reloadData()
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
            self.onErrorHandling?("Could not retrieve playlists.  Please check your connection and try again.")
//            showError()
        }
        
    }

}
