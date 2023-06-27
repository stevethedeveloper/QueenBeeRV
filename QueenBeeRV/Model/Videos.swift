//
//  Videos.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/12/23.
//

import Foundation

struct Videos: Decodable {
    var etag: String
    var nextPageToken: String?
    var items: [Video]
}

