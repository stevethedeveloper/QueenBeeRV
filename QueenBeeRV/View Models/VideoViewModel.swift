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
    private let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    private let youtubeChannelID = Bundle.main.infoDictionary?["YOUTUBE_CHANNEL_ID"] as? String
    let youtubeAllVideosPlaylistID = Bundle.main.infoDictionary?["YOUTUBE_ALL_VIDEOS_PLAYLIST_ID"] as? String
    
    private let placeholderImage = UIImage(named: "placeholder")
    private let urlSession = URLSession.shared

    var onErrorHandling: ((String) -> Void)?

    var latestVideos: Videos?
    var allPlaylists: Playlists?
    var data: Observable<[LatestVideos]> = Observable([])
    

    func fetchLatestVideos() async {
        let url: URL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(youtubeAllVideosPlaylistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10")!
        
        do {
            let (returnData, _) = try await urlSession.data(from: url)
            self.parseVideos(json: returnData)
            if let allVideos = self.latestVideos?.items {
                if allVideos.count > 0 {
                    // add this at any position and playlists at position 0, will throw error if trying to add to position 1 and array is empty
                    self.data.value.append(LatestVideos.init(sectionName: VideoTableSectionTitle.videoSectionTitle.rawValue, videos: allVideos))
                }
            }
        } catch {
            onErrorHandling?("Could not retrieve videos.  Please check your connection and try again.")
        }
    }
        
    private func parseVideos(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let videoDecoded = try decoder.decode(Videos.self, from: json)
            self.latestVideos = videoDecoded.items.count > 0 ? videoDecoded : nil
        } catch {
            self.onErrorHandling?("Could not retrieve videos.  Please check your connection and try again.")
        }
        
    }
    
    func fetchPlaylists() async {
        let url: URL = URL(string: "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&channelId=\(youtubeChannelID ?? "")&key=\(youtubeKey ?? "")")!

        do {
            let (returnData, _) = try await urlSession.data(from: url)
            self.parsePlaylists(json: returnData)
            if let allPlaylists = self.allPlaylists?.items {
                if allPlaylists.count > 0 {
                    // always add this to position 0 so it comes first
                    self.data.value.insert(LatestVideos.init(sectionName: VideoTableSectionTitle.playlistSectionTitle.rawValue, playlists: allPlaylists), at: 0)
                }
            }
        } catch {
            onErrorHandling?("Could not retrieve playlists.  Please check your connection and try again.")
        }
    }

    private func parsePlaylists(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let playlistsDecoded = try decoder.decode(Playlists.self, from: json)
            self.allPlaylists = playlistsDecoded.items.count > 0 ? playlistsDecoded : nil
        } catch {
            self.onErrorHandling?("Could not decode playlists.  Please check your connection and try again.")
        }
        
    }

}
