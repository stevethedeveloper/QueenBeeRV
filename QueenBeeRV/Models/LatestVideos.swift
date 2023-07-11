//
//  LatestVideos.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/19/23.
//

import Foundation

struct LatestVideos {
    var sectionName: String?
    var videos: [Video]?
    var playlists: [Playlist]?
    
    init(sectionName: String? = nil, videos: [Video]? = nil) {
        self.sectionName = sectionName
        self.videos = videos
        self.playlists = nil
    }
    
    init(sectionName: String? = nil, playlists: [Playlist]? = nil) {
        self.sectionName = sectionName
        self.playlists = playlists
        self.videos = nil
    }
}
