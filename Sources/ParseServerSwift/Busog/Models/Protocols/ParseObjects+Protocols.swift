//
//  Protocols.swift
//  Lokality
//
//  Created by Jayson Ng on 2/6/22.
//

import Foundation

// MARK: - --------------  Protocols  ---------------
public protocol ObjectIdable {
    var objectId: String { get }
}

public protocol JSONable {
    associatedtype Element = Self
    static var jsonfile: [Element] { get }
}
