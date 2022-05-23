//
//  Robot.swift
//  Xplor
//
//  Created by abc on 22/5/22.
//

import Foundation


struct Robot {
    var state: State?
    var reportStateBlock: ((State) -> Void)?
    
    // Executes the given command and returns a new changed state
    // or `nil` if the command was invalid
    @discardableResult
    mutating func handleCommand(_ command: Command) -> State? {
        var newState: State?
        
        switch command {
        case .place(x: let x, y: let y, f: let f):
            newState = State(x: x, y: y, facing: f)
        case .move:
            // Move one unit forward in the direction the robot is facing
            newState = state?.move()
        case .left:
            // Rotate 90 degrees left without changing the position
            newState = state?.left()
        case .right:
            // Rotate 90 degrees right without changing the position
            newState = state?.right()
        case .report:
            // Announce the X,Y and F of the robot (e.g. to the standard output)
            if let state = state {
                reportStateBlock?(state)
                return state
            }
        }
        
        if let newState = newState, newState.isValid {
            state = newState
            return state
        }
        return nil
    }
}
