//
//  Observable.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/7/23.
//

import Foundation

final class Observable<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
