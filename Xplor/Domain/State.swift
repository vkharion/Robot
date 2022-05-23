//
//  State.swift
//  Xplor
//
//  Created by abc on 22/5/22.
//

import Foundation

struct State: Equatable {
    let x: Int
    let y: Int
    let facing: Facing
}

extension State {
    static let xEndIndex: Int = 5
    static let yEndIndex: Int = 5
    
    var isValid: Bool {
        return (0..<State.xEndIndex).contains(x)
            && (0..<State.yEndIndex).contains(y)
    }
    
    func move() -> State {
        // Move one unit forward in the direction the robot is facing
        // The origin (0,0) is considered to be the SOUTH WEST most corner.
        var newX = x
        var newY = y
        switch facing {
        case .north:
            newY += 1
        case .south:
            newY -= 1
        case .east:
            newX += 1
        case .west:
            newX -= 1
        }
        return State(x: newX, y: newY, facing: facing)
    }

    func left() -> State {
        // Rotate 90 degrees left without changing the position
        let newFacing = facing.left()
        return State(x: x, y: y, facing: newFacing)
    }

    func right() -> State {
        // Rotate 90 degrees right without changing the position
        let newFacing = facing.right()
        return State(x: x, y: y, facing: newFacing)
    }
}

extension State: CustomStringConvertible {
    var description: String {
        return "\(x),\(y),\(facing.rawValue)"
    }
}
