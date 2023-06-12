//
//  Playlist.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import Foundation

public struct Playlist: Decodable {
    var id: String
    var publishedAt: String
    var title: String
    var description: String
    var thumbnailSmall: String
    var thumbnailLarge: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case snippet
    }
    
    private enum PlaylistItemCodingKeys: String, CodingKey {
        case title, description, publishedAt, thumbnails
    }

    private enum PlaylistItemThumbnailCodingKeys: String, CodingKey {
        case standard, `default`
    }
    
    private enum PlaylistItemThumbnailDetailsCodingKeys: String, CodingKey {
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try rootContainer.decode(String.self, forKey: .id)
        
        let snippet = try rootContainer.nestedContainer(keyedBy: PlaylistItemCodingKeys.self, forKey: CodingKeys.snippet)
        self.title = try snippet.decode(String.self, forKey: .title)
        self.description = try snippet.decode(String.self, forKey: .description)
        self.publishedAt = try snippet.decode(String.self, forKey: .publishedAt)
        
        let thumbnails = try snippet.nestedContainer(keyedBy: PlaylistItemThumbnailCodingKeys.self, forKey: PlaylistItemCodingKeys.thumbnails)
        let thumbnailLargeDetails = try thumbnails.nestedContainer(keyedBy: PlaylistItemThumbnailDetailsCodingKeys.self, forKey: PlaylistItemThumbnailCodingKeys.standard)
        let thumbnailSmallDetails = try thumbnails.nestedContainer(keyedBy: PlaylistItemThumbnailDetailsCodingKeys.self, forKey: PlaylistItemThumbnailCodingKeys.default)
        self.thumbnailLarge = try thumbnailLargeDetails.decode(String.self, forKey: .url)
        self.thumbnailSmall = try thumbnailSmallDetails.decode(String.self, forKey: .url)
    }
}

