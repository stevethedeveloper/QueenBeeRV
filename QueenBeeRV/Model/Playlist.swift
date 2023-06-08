//
//  Playlist.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import Foundation

struct Playlist: Codable {
    var id: String
    var publishedAt: Date
    var title: String
    var description: String
    var thumbnailSmall: String
    var thumbnailLarge: String
}

//enum CodingKeys: String, CodingKey {
//    case 
//}
