//
//  Command.swift
//  Xplor
//
//  Created by abc on 22/5/22.
//

import Foundation

enum Command: Equatable {
    case place(x: Int, y: Int, f: Facing) // e.g. PLACE 0,0,NORTH
    case move
    case left
    case right
    case report
}

extension Command {
    
    struct Constants {
        static let move = "MOVE"
        static let left = "LEFT"
        static let right = "RIGHT"
        static let report = "REPORT"
        static let place = "PLACE"
    }
    
    init?(value: String) {
        switch value {
        case Constants.move:
            self = .move
        case Constants.left:
            self = .left
        case Constants.right:
            self = .right
        case Constants.report:
            self = .report
        default:
            let pattern = "^\(Constants.place) (\\d),(\\d),(\\w+)$"
            //+ #"(\d),(\d),(\w+)$"# // Swift 5 raw string literal
            if let captures = pattern.firstMatchCaptures(in: value), captures.count == 3 {
                if let x = Int(captures[0]), let y = Int(captures[1]), let f = Facing(rawValue: captures[2]) {
                    self = .place(x: x, y: y, f: f)
                    return
                }
            }
            return nil
        }
    }
}

extension Command: CustomStringConvertible {
    var description: String {
        switch self {
        case .place(x: let x, y: let y, f: let f):
            return "\(Constants.place) \(x),\(y),\(f.rawValue)"
        case .move:
            return Constants.move
        case .left:
            return Constants.left
        case .right:
            return Constants.right
        case .report:
            return Constants.report
        }
    }
}
