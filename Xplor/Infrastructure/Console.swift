//
//  Console.swift
//  Xplor
//
//  Created by abc on 21/5/22.
//

import Foundation

protocol ConsoleInputProtocol {
    func readLine() -> String?
}

class Console: ConsoleInputProtocol {
    var errStream = StandardErrorOutputStream()
    
    func readLine() -> String? {
        return Swift.readLine()
    }
    
    func print(_ message: String) {
        Swift.print(message)
    }
    
    func printError(_ error: Error) {
        Swift.print("\(error)", to: &errStream)
    }
}

struct StandardErrorOutputStream: TextOutputStream {
    let stderr = FileHandle.standardError

    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            fatalError()
        }
        stderr.write(data)
    }
}
