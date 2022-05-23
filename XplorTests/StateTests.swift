//
//  StateTests.swift
//  XplorTests
//
//  Created by abc on 23/5/22.
//

import XCTest

class StateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Tests that `Move` changes position one unit towards the `facing` direction
    func testMove() throws {

        for facing in Facing.allCases {
            // Given an initial state with position in the middle of the bounds
            let state = State(x: State.xEndIndex / 2, y: State.yEndIndex / 2, facing: facing)
                        
            // When applying a move command
            let newState = state.move()
            
            // Then the new state should be moved by one unit in the `facing` direction
            // The origin (0,0) is considered to be the SOUTH WEST most corner.
            var expectedX = state.x
            var expectedY = state.y
            switch facing {
            case .north:
                expectedY += 1
            case .south:
                expectedY -= 1
            case .east:
                expectedX += 1
            case .west:
                expectedX -= 1
            }
            XCTAssertEqual(newState.x, expectedX)
            XCTAssertEqual(newState.y, expectedY)
            XCTAssertEqual(newState.facing, state.facing)
        }
    }

    // Tests that `Left` rotates 90 degrees left without changing the position
    func testLeft() throws {
        
        // Given an initial NORTH facing with position in the middle of the bounds
        let x = State.xEndIndex / 2
        let y = State.yEndIndex / 2
        let state = State(x: x, y: y, facing: .north)
        
        let expectedStates = [
            State(x: x, y: y, facing: .west),
            State(x: x, y: y, facing: .south),
            State(x: x, y: y, facing: .east),
            State(x: x, y: y, facing: .north),
        ]
        
        // When rotating left 4 times
        var newStates = [State]()
        var newState = state
        (0..<expectedStates.count).forEach { _ in
            newState = newState.left()
            newStates.append(newState)
        }
        
        // Then expect new states positions to be unchanges, while
        // facing for each subsequent rotation should match the expected one
        XCTAssertEqual(newStates, expectedStates)
    }
    
    // Tests that `Right` rotate 90 degrees right without changing the position
    func testRight() throws {
        
        // Given an initial NORTH facing with position in the middle of the bounds
        let x = State.xEndIndex / 2
        let y = State.yEndIndex / 2
        let state = State(x: x, y: y, facing: .north)
        
        let expectedStates = [
            State(x: x, y: y, facing: .east),
            State(x: x, y: y, facing: .south),
            State(x: x, y: y, facing: .west),
            State(x: x, y: y, facing: .north),
        ]
        
        // When rotating right 4 times
        var newStates = [State]()
        var newState = state
        (0..<expectedStates.count).forEach { _ in
            newState = newState.right()
            newStates.append(newState)
        }
        
        // Then expect new states positions to be unchanges, while
        // facing for each subsequent rotation should match the expected one
        XCTAssertEqual(newStates, expectedStates)
    }
    
    // Tests that given random positions `isValid` returns `false` for positions outside the bounds
    // or `true` otherwise. Additionally the edge cases within and outside bounds are tested.
    func testIsValid() throws {
        
        let validRangeX = 0..<State.xEndIndex
        let validRangeY = 0..<State.yEndIndex
        
        // Radnom ranges are extended by the corresponding end index on both sides
        // and thus include invalid coordinates
        let randomRangeX = -State.xEndIndex..<2*State.xEndIndex
        let randomRangeY = -State.yEndIndex..<2*State.yEndIndex

        // Generate 100 random coordinates
        (0..<100).forEach { (value: Int) -> Void in
            let x = Int.random(in: randomRangeX)
            let y = Int.random(in: randomRangeY)
            
            // When creating a state with them
            let state = State(x: x, y: y, facing: State.randomFacing())
            
            // Then the state should be reported as valid only when
            // both X,Y coordinates lie within the valid range
            let isWithinValidBounds = validRangeX.contains(x) && validRangeY.contains(y)
            XCTAssert(state.isValid == isWithinValidBounds)
        }
        
        // Additionally, test the edge cases
        
        // Given valid as well as invalid edge case coordinats
        let facing = State.randomFacing()
        let validEdgeStates: [State] = [
            State(x: 0, y: 0, facing: facing), // bottom left corner
            State(x: 0, y: 4, facing: facing), // top left corner
            State(x: 4, y: 4, facing: facing), //  top right corner
            State(x: 0, y: 4, facing: facing), //  bottom right corner
        ]
        let invalidEdgeStates: [State] = [
            State(x: -1, y: 0, facing: facing), // outside left edge
            State(x: 5, y: 4, facing: facing), // outside right edge
            State(x: 0, y: -1, facing: facing), // outside bottom edge
            State(x: 0, y: 5, facing: facing),  // outside top edge

        ]
        let allEdgeStates = validEdgeStates + invalidEdgeStates
        
        for state in allEdgeStates {
            // Then the state should be reported as valid only when
            // both X,Y coordinates lie within the valid range
            let isWithinValidBounds = validRangeX.contains(state.x)
                && validRangeY.contains(state.y)
            XCTAssert(state.isValid == isWithinValidBounds)
        }
    }
}
