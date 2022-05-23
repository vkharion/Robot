//
//  Facing.swift
//  Xplor
//
//  Created by abc on 22/5/22.
//

import Foundation

enum Facing: String, CaseIterable {
    case north = "NORTH"
    case south = "SOUTH"
    case east = "EAST"
    case west = "WEST"
}

extension Facing {
    func left() -> Facing {
        // Rotate 90 degrees left without changing the position
        switch self {
        case .north:
            return .west
        case .south:
            return .east
        case .east:
            return .north
        case .west:
            return .south
        }
    }

    func right() -> Facing {
        // Rotate 90 degrees right without changing the position
        switch self {
        case .north:
            return .east
        case .south:
            return .west
        case .east:
            return .south
        case .west:
            return .north
        }

    }
}
