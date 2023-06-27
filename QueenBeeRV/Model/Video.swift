//
//  Video.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import Foundation

public struct Video: Decodable {
    var id: String
    var publishedAt: String
    var title: String
    var description: String
    var playlistId: String
    var thumbnailSmall: String
//    var thumbnailLarge: String
    var videoId: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case snippet
    }

    private enum VideoCodingKeys: String, CodingKey {
        case title, description, publishedAt, thumbnails, playlistId, resourceId
    }

    private enum VideoResourceCodingKeys: String, CodingKey {
        case videoId
    }

    private enum VideoThumbnailCodingKeys: String, CodingKey {
        case `default`
    }

    private enum VideoThumbnailDetailsCodingKeys: String, CodingKey {
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try rootContainer.decode(String.self, forKey: .id)

        let snippet = try rootContainer.nestedContainer(keyedBy: VideoCodingKeys.self, forKey: CodingKeys.snippet)
        self.title = try snippet.decode(String.self, forKey: .title)
        self.description = try snippet.decode(String.self, forKey: .description)
        self.publishedAt = try snippet.decode(String.self, forKey: .publishedAt)
        self.playlistId = try snippet.decode(String.self, forKey: .playlistId)

        let thumbnails = try snippet.nestedContainer(keyedBy: VideoThumbnailCodingKeys.self, forKey: VideoCodingKeys.thumbnails)
        if !thumbnails.allKeys.isEmpty {
            //            let thumbnailLargeDetails = try thumbnails.nestedContainer(keyedBy: VideoThumbnailDetailsCodingKeys.self, forKey: VideoThumbnailCodingKeys.standard)
            let thumbnailSmallDetails = try thumbnails.nestedContainer(keyedBy: VideoThumbnailDetailsCodingKeys.self, forKey: VideoThumbnailCodingKeys.default)
            //            self.thumbnailLarge = try thumbnailLargeDetails.decodeIfPresent(String.self, forKey: .url) ?? ""
            self.thumbnailSmall = try thumbnailSmallDetails.decodeIfPresent(String.self, forKey: .url) ?? ""
        } else {
            self.thumbnailSmall = ""
        }
        
        let resourceId = try snippet.nestedContainer(keyedBy: VideoResourceCodingKeys.self, forKey: VideoCodingKeys.resourceId)
        self.videoId = try resourceId.decode(String.self, forKey: .videoId)
    }

}
