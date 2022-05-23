//
//  RobotTests.swift
//  XplorTests
//
//  Created by abc on 22/5/22.
//

import XCTest

class RobotTests: XCTestCase {
    var robot: Robot!

    override func setUpWithError() throws {
        robot = Robot()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Tests that PLACE command
    // 1) Is the first valid command to the robot. Until then all commands are discarded
    // 2) Another PLACE command(s) can be issued afterwards
    // 3) Is ignored if the position is outside of valid bounds
    func testPlace() throws {
        
        // Given no prior PLACE command was issued
        
        // When REPORT is issued
        let reportedState = robot.handleCommand(.report)
        
        // Then we expect the command to be ignored
        XCTAssertNil(reportedState)
        
                
        // Given the first valid PLACE command was issued
        let x1 = State.randomX()
        let y1 = State.randomY()
        let f1 = State.randomFacing()
        let placeCommand1 = Command.place(x: x1, y: y1, f: f1)
        let placeState1 = robot.handleCommand(placeCommand1)
                
        
        // Then the state returned by `handleCommand` should be correct
        // and be equal the current robot state
        let expectedState1 = State(x: x1, y: y1, facing: f1)
        XCTAssertEqual(placeState1, expectedState1)
        XCTAssertEqual(placeState1, robot.state)
        
        
        // Test that another PLACE command(s) can be issued afterwards
        
        // Given another valid PLACE command was issued
        let x2 = State.randomX()
        let y2 = State.randomY()
        let f2 = State.randomFacing()
        let placeCommand2 = Command.place(x: x2, y: y2, f: f2)
        let placeState2 = robot.handleCommand(placeCommand2)
        
        // Then the state returned by `handleCommand` should be correct
        // and be equal the current robot state
        let expectedState2 = State(x: x2, y: y2, facing: f2)
        XCTAssertEqual(placeState2, expectedState2)
        XCTAssertEqual(placeState2, robot.state)
        
        // Test that PLACE command is ignored if the position is outside of valid bounds
        
        // Given another valid PLACE command was issued
        let x3 = State.randomX()
        let y3 = State.yEndIndex
        let f3 = State.randomFacing()
        let placeCommand3 = Command.place(x: x3, y: y3, f: f3)
        let placeState3 = robot.handleCommand(placeCommand3)
        
        // Then no state should be returned by `handleCommand`
        // and the robot state should be unchanged
        XCTAssertNil(placeState3)
        XCTAssertEqual(placeState2, robot.state)
    }
    
    // Tests that MOVE command
    // 1) Is ignored unless the state is initialiazed with PLACE command
    // 2) Changes the state by moving one unit forward in the current facing direction
    // 3) Is ignored if the resulting position is outside of valid bounds
    // 4) Is executed when it's a subsequent valid command
    func testMove() throws {
        
        // Given no prior PLACE command was issued
        
        // When MOVE is issued
        let reportedState = robot.handleCommand(.move)
        
        // Then we expect the command to be ignored
        XCTAssertNil(reportedState)
        
                
        // Test subsequent MOVE command changes the state by moving one unit towards the current facing direction
                
        for facing in Facing.allCases {
            
            // Given the first valid PLACE command was issued with the center position
            let x1 = State.xEndIndex / 2
            let y1 = State.yEndIndex / 2
            let placeCommand = Command.place(x: x1, y: y1, f: facing)
            let placeState = robot.handleCommand(placeCommand)
            
            // When MOVE is issued
            let moveState = robot.handleCommand(.move)
                        
            // Then the state returned by `handleCommand` should be correct
            // and be equal the current robot state
            XCTAssertEqual(moveState, placeState?.move())
            XCTAssertEqual(moveState, robot.state)
        }
        
        
        // Test that MOVE command is ignored if the resulting position is outside of valid bounds
        
        // Given the PLACE command at the bottom left position facing west
        let placeCommand = Command.place(x: 0, y: 0, f: .west)
        let placeState = robot.handleCommand(placeCommand)
        
        // When issuing the MOVE command
        let invalidMoveState = robot.handleCommand(.move)
        
        // Then no state should be returned and the robot state should be unchanged
        XCTAssertNil(invalidMoveState)
        XCTAssertEqual(placeState, robot.state)
        
        
        // Test that a subsequent valid MOVE command is executed
        
        // Given the rotate right command changing the facing direction to north
        let rotateRightState = robot.handleCommand(.right)
        
        // When issuing a subsequent valid MOVE command
        let subsequentValidMoveState = robot.handleCommand(.move)
        
        // Then we expect it to be executed with the correct new position
        XCTAssertNotNil(subsequentValidMoveState)
        XCTAssertEqual(subsequentValidMoveState, rotateRightState?.move())
    }
    
    // Tests that LEFT command
    // 1) Is ignored unless the state is initialiazed with PLACE command
    // 2) Changes the current facing direction by rotating 90 degrees to the left
    //    while leaving the position unchanged
    func testLeft() throws {
        
        // Given no prior PLACE command was issued
        
        // When LEFT is issued
        let reportedState = robot.handleCommand(.left)
        
        // Then we expect the command to be ignored
        XCTAssertNil(reportedState)
        
                
        // Test that subsequent LEFT commands change the current facing direction
        // by rotating 90 degrees to the left while leaving the position unchanged
        
        // Given a valid PLACE command was issued with the center position facing north
        let x = State.xEndIndex / 2
        let y = State.yEndIndex / 2
        let placeCommand = Command.place(x: x, y: y, f: .north)
        robot.handleCommand(placeCommand)
        
        let expectedStates = [
            State(x: x, y: y, facing: .west),
            State(x: x, y: y, facing: .south),
            State(x: x, y: y, facing: .east),
            State(x: x, y: y, facing: .north),
        ]
                
        // When LEFT is issued 4 times
        let moveStates = (0..<expectedStates.count).map { _ in
            robot.handleCommand(.left)
        }
                    
        // Then the returned states by `handleCommand` should be as exected
        XCTAssertEqual(moveStates, expectedStates)
    }
    
    // Tests that RIGHT command
    // 1) Is ignored unless the state is initialiazed with PLACE command
    // 2) Changes the current facing direction by rotating 90 degrees to the right
    //    while leaving the position unchanged
    func testRight() throws {
        
        // Given no prior PLACE command was issued
        
        // When RIGHT is issued
        let reportedState = robot.handleCommand(.right)
        
        // Then we expect the command to be ignored
        XCTAssertNil(reportedState)
        
                
        // Test that subsequent RIGHT commands change the current facing direction
        // by rotating 90 degrees to the right while leaving the position unchanged
        
        // Given a valid PLACE command was issued with the center position facing north
        let x = State.xEndIndex / 2
        let y = State.yEndIndex / 2
        let placeCommand = Command.place(x: x, y: y, f: .north)
        robot.handleCommand(placeCommand)
        
        let expectedStates = [
            State(x: x, y: y, facing: .east),
            State(x: x, y: y, facing: .south),
            State(x: x, y: y, facing: .west),
            State(x: x, y: y, facing: .north),
        ]
                
        // When RIGHT is issued 4 times
        let moveStates = (0..<expectedStates.count).map { _ in
            robot.handleCommand(.right)
        }
                    
        // Then the returned states by `handleCommand` should be as exected
        XCTAssertEqual(moveStates, expectedStates)
    }

    // Tests that REPORT command
    // 1) Is ignored unless the state is initialiazed with PLACE command
    // 2) Invokes `reportStateBlock` handler with the correct state when preceeded by PLACE command
    func testReport() throws {
        let expectation1 = XCTestExpectation(description: "reportStateBlock not called")
        expectation1.isInverted = true
        let expectation2 = XCTestExpectation(description: "reportStateBlock is called")
        
        // Given no prior PLACE command was issued
        robot.reportStateBlock = { state in
            expectation1.fulfill()
        }
        
        // When REPORT is issued
        robot.handleCommand(.report)
        
        // Then we expect it to be ignored
        wait(for: [expectation1], timeout: 1.0)
        
                
        // Given a prior PLACE command was issued
        let x = State.randomX()
        let y = State.randomY()
        let f = State.randomFacing()
        let placeCommand = Command.place(x: x, y: y, f: f)
        robot.handleCommand(placeCommand)
        
        var reportedState: State?
        robot.reportStateBlock = { state in
            reportedState = state
            expectation2.fulfill()
        }
        
        // When REPORT is issued
        robot.handleCommand(.report)
        
        // Then the reported state should be the same as the PLACE command
        wait(for: [expectation2], timeout: 1.0)
        
        XCTAssertEqual(reportedState?.x, x)
        XCTAssertEqual(reportedState?.y, y)
        XCTAssertEqual(reportedState?.facing, f)
    }

}
