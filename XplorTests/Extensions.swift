//
//  Extensions.swift
//  XplorTests
//
//  Created by abc on 22/5/22.
//

import Foundation

extension State {
    
    // Returns a random valid x-coordinate within allowed bounds
    static func randomX() -> Int {
        return Int.random(in: 0..<State.xEndIndex)
    }
    
    // Returns a random valid y-coordinate within allowed bounds
    static func randomY() -> Int {
        return Int.random(in: 0..<State.yEndIndex)
    }
    
    // Returns a random `Facing` enumeration case
    static func randomFacing() -> Facing {
        let idx = Int.random(in: 0..<Facing.allCases.count)
        return Facing.allCases[idx]
    }
}
