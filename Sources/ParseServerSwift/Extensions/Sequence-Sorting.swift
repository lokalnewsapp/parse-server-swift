//
//  Sequence-Sorting.swift
//  Lokality
//
//  Created by Jayson Ng on 9/30/21.
//
//  See: https://www.hackingwithswift.com/plus/ultimate-portfolio-app/custom-sorting-for-items

import Foundation

extension Sequence {
  func sorted<Value>(
    by keyPath: KeyPath<Element, Value>,
    using areInIncreasingOrder: (Value, Value) throws -> Bool
  ) rethrows -> [Element] {
    try self.sorted {
      try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
    }
  }

  func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
    self.sorted(by: keyPath, using: <)
  }

}
