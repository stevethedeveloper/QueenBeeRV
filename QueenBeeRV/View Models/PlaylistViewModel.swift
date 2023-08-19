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

    private let urlSession = URLSession.shared

    var playlistID: String?
    var playlistName: String?
    var selectedVideo: Observable<Video?> = Observable(nil)

    var playlist: Videos?
    var videos: Observable<[Video]> = Observable([])

    var isLoading = false

    func fetchPlaylist(nextPageToken: String? = nil) async {
        var loadingMore: Bool = false
        var urlString: String
        if let token = nextPageToken {
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10&pageToken=\(token)"
            loadingMore = true
        } else {
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID ?? "")&key=\(youtubeKey ?? "")&maxResults=10"
        }
        let url: URL = URL(string: urlString)!

        do {
            let (returnData, _) = try await urlSession.data(from: url)
            parseVideos(json: returnData, loadingMore: loadingMore)
                        
            // Write to main thread
            DispatchQueue.main.async {
                if self.videos.value.count > 0 {
                    if self.selectedVideo.value == nil {
                        self.selectedVideo.value = self.videos.value[0]
                    }
                }
            }
        } catch {
            onErrorHandling?("Could not retrieve videos.  Please check your connection and try again.")
        }
    }
    
    func loadMoreVideos() {
        guard playlist?.nextPageToken != nil else {
            isLoading = false
            return
        }
        
        if !isLoading {
            isLoading = true
            Task {
                await fetchPlaylist(nextPageToken: playlist?.nextPageToken)
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func parseVideos(json: Data, loadingMore: Bool = false) {
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
            self.onErrorHandling?("Could not parse playlist.  Please check your connection and try again.")
        }
    }

}
