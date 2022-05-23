//
//  CommandSource.swift
//  Xplor
//
//  Created by abc on 22/5/22.
//

import Foundation

class CommandSource {
    let command = Observable<Command?>(nil)
    let error = Observable<Error?>(nil)
        
    func readFile(_ filename: String, fileManager: TextFileInputProtocol = TextFileManager()) {
        let result = fileManager.readFile(filename)
        switch result {
        case .success(let lines):
            lines.filter { !$0.isEmpty }.forEach { executeCommand($0) }
        case .failure(let error):
            self.error.value = error
        }
    }
    
    func readLine(_ console: ConsoleInputProtocol) -> Bool {
        if let line = console.readLine() {
            executeCommand(line)
            return true
        }
        return false
    }
    
    private func executeCommand(_ line: String) {
        if let command = Command(value: line) {
            self.command.value = command
        } else {
            error.value = Errors.unrecognizedCommand(line)
        }
    }
}

