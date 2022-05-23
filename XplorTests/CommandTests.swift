//
//  CommandTests.swift
//  XplorTests
//
//  Created by abc on 22/5/22.
//

import XCTest

class CommandTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Tests that MOVE command is recognised
    func testMove() throws {
        // Given the MOVE text command
        let stringValue = "MOVE"
        
        // When creating a command from it
        let command = Command(value: stringValue)
        
        // Then we expect it be a move command
        let expected = Command.move
        XCTAssertEqual(command, expected)
    }

    // Tests that LEFT command is recognised
    func testLeft() throws {
        // Given the LEFT text command
        let stringValue = "LEFT"
        
        // When creating a command from it
        let command = Command(value: stringValue)
        
        // Then we expect it be a move command
        let expected = Command.left
        XCTAssertEqual(command, expected)
    }
    
    // Tests that RIGHT command is recognised
    func testRight() throws {
        // Given the RIGHT text command
        let stringValue = "RIGHT"
        
        // When creating a command from it
        let command = Command(value: stringValue)
        
        // Then we expect it be a move command
        let expected = Command.right
        XCTAssertEqual(command, expected)
    }
    
    // Tests that REPORT command is recognised
    func testReport() throws {
        // Given the REPORT text command
        let stringValue = "REPORT"
        
        // When creating a command from it
        let command = Command(value: stringValue)
        
        // Then we expect it be a move command
        let expected = Command.report
        XCTAssertEqual(command, expected)
    }

    // Tests that PLACE command with different arguments is correctly recognised
    func testPlace() throws {
        // Given valid PLACE text commands
        let validStringValues = [
            "PLACE 0,0,NORTH",
            "PLACE 0,1,SOUTH",
            "PLACE 1,0,EAST",
            "PLACE 1,1,WEST",
        ]
        
        // When creating commands from them
        let commands = validStringValues.map { Command(value: $0) }
        
        // Then created commands should match expected ones
        let expected = [
            Command.place(x: 0, y: 0, f: .north),
            Command.place(x: 0, y: 1, f: .south),
            Command.place(x: 1, y: 0, f: .east),
            Command.place(x: 1, y: 1, f: .west),
        ]
        XCTAssertEqual(commands, expected)
        
        // Test also cases when some of the arguments aren't provided or are invalid
        
        // Given invalid various PLACE text commands
        let invalidStringValues = [
            "PLACE 0 0 NORTH",
            "PLACE 0, 0, NORTH",
            "PLACE 0,0,NORTH1",
            "PLACE NORTH",
            "PLACE 0,1,",
            "PLACE 1,0",
            "PLACE 1,",
            "PLACE 1",
            "PLACE ",
            "PLACE",
        ]

        // When creating commands from them
        let invalidCommands = invalidStringValues.map { Command(value: $0) }
        
        // Then we expect no commands to be created
        XCTAssert(invalidCommands.count == invalidStringValues.count)
        XCTAssert(invalidCommands.compactMap { $0 }.count == 0)
    }
    
    // Tests that any command apart from supported ones (listed above) are unrecognised
    func testUnrecognized() throws {
        // Given the TEST text command
        let stringValue = "TEST"
        
        // When creating a command from it
        let command = Command(value: stringValue)
        
        // Then we expect the command to be `nil`
        XCTAssertNil(command)
    }
}
