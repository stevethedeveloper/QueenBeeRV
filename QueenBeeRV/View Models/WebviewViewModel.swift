//
//  WebviewViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 8/25/23.
//

import Foundation

public class WebviewViewModel {
    var onErrorHandling: ((String) -> Void)?
    var currentWebsite: Observable<String> = Observable("")
}
