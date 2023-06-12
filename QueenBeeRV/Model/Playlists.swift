//
//  Playlists.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/7/23.
//

import Foundation

struct Playlists: Decodable {
    var etag: String
    var items: [Playlist]
}
