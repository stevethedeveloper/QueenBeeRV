//
//  PlaylistViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/8/23.
//

import Foundation

public class PlaylistViewModel {
    var onErrorHandling: ((String) -> Void)?
    private let youtubeKey = Bundle.main.infoDictionary?["YOUTUBE_KEY"] as? String
    private let youtubeChannelID = Bundle.main.infoDictionary?["YOUTUBE_CHANNEL_ID"] as? String
    private let youtubeAllVideosPlaylistID = Bundle.main.infoDictionary?["YOUTUBE_ALL_VIDEOS_PLAYLIST_ID"] as? String

    var playlistID: String?
    var playlistName: String?
    var selectedVideo: Observable<Video?> = Observable(nil)

    var playlist: Videos?
    var videos: Observable<[Video]> = Observable([])


    var isLoading = false

    func fetchPlaylist(nextPageToken: String? = nil) {
        var loadingMore: Bool = false
        var urlString: String
        if let token = nextPageToken {
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10&pageToken=\(token)"
            loadingMore = true
        } else {
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10"
        }
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        // TODO: implement etag
        //        request.setValue("94GJ_J4sdWd_UmWSFt7hnr1Zn_g", forHTTPHeaderField: "If-None-Match")
        //        request.allHTTPHeaderFields?["If-None-Match"] = "4072u9p5TkOOjeUoWj1hoDIN3sI"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                self.onErrorHandling?("Could not retrieve playlist.  Please check your connection and try again.")
            }
            guard let data = data else { return }
            self.parseVideos(json: data, loadingMore: loadingMore)
            DispatchQueue.main.async {
                if self.videos.value.count > 0 {
//                    self.tableView?.reloadData()
                    if self.selectedVideo.value == nil {
                        self.selectedVideo.value = self.videos.value[0]
//                        self.displayVideo(self.selectedVideo)
                    }
                }
            }
        }.resume()
    }
    
    func loadMoreVideos() {
        guard playlist?.nextPageToken != nil else {
            isLoading = false
            return
        }
        
        if !isLoading {
            isLoading = true
            fetchPlaylist(nextPageToken: playlist?.nextPageToken)
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                DispatchQueue.main.async {
//                    self.tableView?.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    func parseVideos(json: Data, loadingMore: Bool = false) {
        let decoder = JSONDecoder()
        do {
            let videoDecoded = try decoder.decode(Videos.self, from: json)
            if loadingMore {
                playlist?.etag = videoDecoded.etag
                playlist?.nextPageToken = videoDecoded.nextPageToken
                videos.value.append(contentsOf: videoDecoded.items)
            } else {
                playlist = videoDecoded.items.count > 0 ? videoDecoded : nil
                videos.value = videoDecoded.items
            }
            videos.value.removeAll(where: {$0.title.contains("Private")})
        } catch {
            self.onErrorHandling?("Could not retrieve playlist.  Please check your connection and try again.")
//            showError()
        }
    }

}
