//
//  String.swift
//  Xplor
//
//  Created by abc on 21/5/22.
//

import Foundation

// MARK: - Regular expression helpers

extension String {
    
    // Returns a range for the string
    var fullRange: NSRange {
        return NSRange(self.startIndex..<self.endIndex, in: self)
    }
    
    // Returns all captures from the first match in the given string
    func firstMatchCaptures(in string: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: self, options: []) else {
            return nil
        }
        if let match = regex.firstMatch(in: string, options: [], range: string.fullRange) {
            // For each matched range, extract the capture group
            return (0..<match.numberOfRanges).compactMap { rangeIndex in
                let range = match.range(at: rangeIndex)
                
                // Ingore the entire string
                if range == string.fullRange {
                    return nil
                }
                
                // Extract the substring matching the capture group
                if let substringRange = Range(range, in: string) {
                    return String(string[substringRange])
                }
                return nil
            }
        }
        return nil
    }
}
