//
//  BlogPostViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/10/23.
//

import Foundation

public class BlogPostViewModel {
    var onErrorHandling: ((String) -> Void)?
    var currentWebsite: Observable<String> = Observable("")
}
