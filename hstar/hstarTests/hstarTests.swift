//
//  hstarTests.swift
//  hstarTests
//
//  Created by Austin Ellis on 12/6/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import XCTest
@testable import hstar

class hstarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    test the hedge face enum,
    each value should have an opposite and a list of sides
     */
    func testHedgeFace()
    {
        for i in 1...6
        {
            let face = HedgeFace(rawValue: i)!
            let opposite = face.opposite()
            //test opposite
            XCTAssertEqual(opposite.rawValue, 7-i)
            //test sides
            for side in face.sides()
            {
                XCTAssertNotEqual(side, opposite)
            }
        }
    }
    
    /**
     Test the hedge orientation and rotation
     we sould be able to rotate 4 times in each direction and get back to where we started
     */
    func testOrientation()
    {
        //sanity check the rotations
        let orientation = Orientation(top: .one, north: .two)
        XCTAssertEqual(orientation, Orientation(top: .one, north: .two))
        XCTAssertEqual(try orientation.rotate(to: .north), Orientation(top: .five, north: .one))
        XCTAssertEqual(try orientation.rotate(to: .south), Orientation(top: .two, north: .six))
        XCTAssertEqual(try orientation.rotate(to: .east), Orientation(top: .four, north: .two))
        XCTAssertEqual(try orientation.rotate(to: .west), Orientation(top: .three, north: .two))
        
        //make sure that everything rolls back to the start
        for dir in Direction.all()
        {
            XCTAssertEqual(orientation,
                           try orientation
                                .rotate(to: dir)
                                .rotate(to: dir)
                                .rotate(to: dir)
                                .rotate(to: dir)
                           )
        }
    }
    /**
     Bad states throw invalidOrientation errors
     */
    func testBadOrientation()
    {
        let orientation = Orientation(top: .one, north: .six)
        XCTAssertThrowsError(try orientation.rotate(to: .west)){ error in
            XCTAssertEqual(error as? HedgeError, HedgeError.invalidOrientation)
        }
    }
    
    /**
     HedgePositions combine orientations and a tile positioon
     */
    func testHedge()
    {
        //create a hedge bottom left
        let hedge = Hedge(
            position: Position(0,0),
            orientation: Orientation(top: .one, north: .two)
        )
        //rotate it around
        for dir in Direction.all()
        {
            let rotated = try! hedge.rotate(to: dir)
            //assert that the hedge hashes differently
            XCTAssertNotEqual(hedge, rotated)
            //the footprint should overlap by 2 or 3 tiles always
            XCTAssert(
                Set<Position>(hedge.footPrint()).intersection( rotated.footPrint()).count > 0
            )
        }
    }
    /**
     bad hedges return nil
     */
    func testBadHedge()
    {
        let hedge = Hedge(position: Position(0,0), orientation: Orientation(top: .one, north: .six))
        XCTAssertThrowsError(try hedge.rotate(to: .west)){ error in
            XCTAssertEqual(error as? HedgeError, HedgeError.invalidOrientation)
        }
    }
    /**
     test win condition
    */
    func testWinCondition()
    {
        XCTAssertEqual(
            goal1,
            Hedge( position: Position(5,2), orientation: Orientation(top: .one, north: .two))
        )
    }
    /**
    test ob
    */
    func testOutOfBounds()
    {
        //start bottom left
        let hedge = Hedge(position: Position(0,0), orientation: Orientation(top: .one, north: .two))
        XCTAssertTrue(hedge.isInBounds())
        //rotating south is ob
        XCTAssertFalse(try! hedge.rotate(to: .south).isInBounds())
        //rotating west is ob
        XCTAssertFalse(try! hedge.rotate(to: .west).isInBounds())
        //we can rotate three full times from one corner to another
        func rotate(h: Hedge, d: Direction)
        {
            var x = h
            for i in 1...4
            {
                x = try! x.rotate(to: d)
                if i < 4 { XCTAssertTrue( x.isInBounds()) }
                else     { XCTAssertFalse(x.isInBounds()) }
            }
        }
        rotate(h: hedge, d: .north)
        rotate(h: hedge, d: .east)
    }
    
    /**
     test pathfinding
     */
    func testPathFromGoalNode()
    {
        let path = try! HStar.shortestPath(from: goal1, obstacles: [])
        XCTAssertEqual(1, path.count)
        XCTAssertEqual(goal1, path[0])
    }
    
    func testBlockedPath()
    {
        let start = try! goal1.rotate(to: .west)
        let obstacles = Set<Position>([goal1.position])
        let path = try! HStar.shortestPath(from: start, obstacles: obstacles)
        XCTAssertEqual(0, path.count)
    }
    
    func testOneRotationPath()
    {
        func test(goalNode: Hedge)
        {
            let start = try! goalNode.rotate(to: .south)
            XCTAssertEqual(goalNode, try start.rotate(to: .north))
            XCTAssert(start.isInBounds())
            let obstacles = Set<Position>([Position(4,2), Position(1,2), Position(2, 4), Position(4, 5)])
            let path = try! HStar.shortestPath(from: start, obstacles: obstacles)
            XCTAssertEqual(2, path.count)
        }
        test(goalNode: goal1)
        test(goalNode: goal2)
    }
    
    func testHedgeFromVideoAt1m25s()
    {
        //create a starting hedge
        let start = Hedge(
            position: Position(x: 1, y: 4), //position
            orientation: Orientation(top: .five, north: .four) //top could have also been .2
        )
        //list of obstacle positions
        let obstacles = Set<Position>([
            Position(x: 1, y: 3),
            Position(x: 2, y: 4),
            Position(x: 3, y: 2),
            Position(x: 6, y: 5)
        ])
        //get the shortest path to the goal
        let path = try! HStar.shortestPath(from: start, obstacles: obstacles)
        XCTAssert(path.count > 0)
        XCTAssertEqual(9, path.count)
    }
}
