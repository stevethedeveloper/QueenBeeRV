//
//  Post.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import Foundation

struct Post: Codable {
    var id: String
    var title: String
    var url: String
    var date_modified: String
    var html_content: String
}
