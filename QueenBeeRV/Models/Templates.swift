//
//  Templates.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 8/3/23.
//

import Foundation

struct Templates: Decodable {
    let templates: [Template]
}

struct Template: Decodable {
    let title: String
    let description: String
    var items: [TemplateItem]
}

struct TemplateItem: Decodable {
    var name: String
}
