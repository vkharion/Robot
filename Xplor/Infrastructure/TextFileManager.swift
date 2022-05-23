//
//  TextFileManager.swift
//  Xplor
//
//  Created by abc on 21/5/22.
//

import Foundation


enum FileError: Error {
    case fileNotFound(String)
    case cannotReadFile(String)
}

protocol FileManagerProtocol {
    func fileExists(atPath path: String) -> Bool
    func contents(atPath path: String) -> Data?
}

extension FileManager: FileManagerProtocol { }


protocol TextFileInputProtocol {
    func readFile(_ filename: String) -> Result<[String], Error>
}

class TextFileManager: TextFileInputProtocol {

    let fileManager: FileManagerProtocol

    init(fileManager: FileManagerProtocol = FileManager.default) {
        self.fileManager = fileManager
    }

    func readFile(_ filename: String) -> Result<[String], Error> {
        // make sure the file exists
        guard fileManager.fileExists(atPath: filename) else {
            return .failure(FileError.fileNotFound(filename))
        }

        guard let data = fileManager.contents(atPath: filename),
              let contents = String(data: data, encoding: .utf8) else {
            return .failure(FileError.cannotReadFile(filename))
        }

        let lines = contents.components(separatedBy: CharacterSet.newlines).filter { !$0.isEmpty }
        return .success(lines)
    }
}



extension FileError: CustomStringConvertible {
    var description: String {
        switch self {
        case .fileNotFound(let filename):
            return "File not found: \(filename)"
        case .cannotReadFile(let filename):
            return "Cannot read file: \(filename)"
        }
    }
}
