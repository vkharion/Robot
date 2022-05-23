//
//  CommandSourceTests.swift
//  XplorTests
//
//  Created by abc on 22/5/22.
//

import XCTest


class CommandSourceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadFile() throws {
        let filenames = ["example-a", "example-b", "example-c"]
        let expected = ["0,1,NORTH", "0,0,WEST", "3,3,NORTH"]

        for (idx, filename) in filenames.enumerated() {
            let expNoErrors = XCTestExpectation(description: "no errors")
            expNoErrors.isInverted = true
            let expValidStateReported = XCTestExpectation(description: "reportStateBlock")
            
            // Given the example file
            let fileManager = MockExampleFileManager(filename: filename)
            let source = CommandSource()
            var robot = Robot()
            
            source.command.observe(on: self) { command in
                guard let command = command else { return }
                robot.handleCommand(command)
            }
            source.error.observe(on: self) { error in
                guard let _ = error else { return }
                expNoErrors.fulfill()
            }
            
            robot.reportStateBlock = { state in
                if state.description == expected[idx] {
                    expValidStateReported.fulfill()
                }
            }
            
            // When loading and executing loaded commands by the robot
            source.readFile(filename, fileManager: fileManager)
            
            
            // Then we expect the correctly reported state with no errors
            wait(for: [expNoErrors, expValidStateReported], timeout: 1.0)
        }
    }

}


fileprivate class MockExampleFileManager: TextFileInputProtocol {
    
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func readFile(_ filename: String) -> Result<[String], Error> {
        if let data = TestUtils.loadResource(filename, withExtension: "txt"), let contents = String(data: data, encoding: .utf8) {
            let lines = contents.components(separatedBy: CharacterSet.newlines).filter { !$0.isEmpty }
            return .success(lines)
        } else {
            return .failure(FileError.fileNotFound(filename))
        }
    }
}
