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
        for dir in Direction.all(){
             let rotated = try! hedge.rotate(to: dir)//{
                //assert that the hedge hashes differently
                XCTAssertNotEqual(hedge, rotated)
                //the footprint should be completely different
                XCTAssert(
                    Set<Position>(hedge.footPrint()).intersection( rotated.footPrint()).count == 0
                )
            //}
            //else{
             //   XCTFail()
            //}
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
    func testWindCondition()
    {
        XCTAssertEqual(
            goalNode,
            Hedge( position: Position(6,2), orientation: Orientation(top: .one, north: .two))
        )
    }
    /**
    test ob
    */
    func testOutOfBounds()
    {
        let hedge = Hedge(position: Position(0,0), orientation: Orientation(top: .one, north: .two))
        XCTAssertFalse(hedge.isOutOfBounds())
        //rotating south is ob
        XCTAssertTrue(try! hedge.rotate(to: .south).isOutOfBounds())
        //rotating west is ob
        XCTAssertTrue(try! hedge.rotate(to: .west).isOutOfBounds())
        //rotating north is okay twice
        XCTAssertFalse(try! hedge.rotate(to: .north).isOutOfBounds())
        XCTAssertFalse(try! hedge.rotate(to: .north).rotate(to: .north).isOutOfBounds())
        XCTAssertTrue( try! hedge.rotate(to: .north).rotate(to: .north).rotate(to: .north).isOutOfBounds())
        //rotating east is okay twice
        XCTAssertFalse(try! hedge.rotate(to: .east).isOutOfBounds())
        XCTAssertFalse(try! hedge.rotate(to: .east).rotate(to: .east).isOutOfBounds())
        XCTAssertTrue(try! hedge.rotate(to: .east).rotate(to: .east).rotate(to: .east).isOutOfBounds())
    }
    
    /**
     test pathfinding
     */
    func testPathFinding()
    {
        
    }
}
