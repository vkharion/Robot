//
//  TestUtils.swift
//  XplorTests
//
//  Created by abc on 22/5/22.
//

import Foundation

class TestUtils {
    // Returns a resource file URL from the test bundle
    class func resourceURL(_ resource: String, withExtension: String) -> URL? {
        return Bundle(for: TestUtils.self).url(forResource: resource, withExtension: withExtension)
    }
    
    // Loads a resource file from the test bundle
    class func loadResource(_ resource: String, withExtension: String) -> Data? {
        if let resourceURL = resourceURL(resource, withExtension: withExtension)  {
            return try? Data(contentsOf: resourceURL)
        }
        return nil
    }
}


