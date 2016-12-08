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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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
        let dirs:[Direction] = [.north, .south, .east, .west]
        for dir in dirs
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
    func testHedgePosition()
    {
        //let hp = HedgePo
    }
}
