//
//  Checklists.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/27/23.
//

import Foundation

struct Checklist: Decodable {
    var items: [ChecklistItem]
}

public struct ChecklistItem: Codable {
    var title: String
    var completed: Bool = false
}
