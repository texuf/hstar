//
//  model.swift
//  hstar
//
//  Created by Austin Ellis on 12/6/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation

/**
 Magic Numbers
 */
struct GameProps
{
    static let numCols = 7
    static let numRows = 7
    static let numObstacles = 4
    static let hedgeFootprintSize = 6
    static let font = "helvetica"
}

/**
 Magic Win Conditions
 
 we're using bottom left coordinate system (like chess)
 and there are 2 win conditions, goal1 and goal2
 */

var goal1: Hedge = Hedge(
    position: Position(x: 5, y: 2),
    orientation: Orientation(top: .one, north: .two)
)

var goal2: Hedge = Hedge(
    position: Position(x: 5, y: 2),
    orientation: Orientation(top: .six, north: .five)
)

/**
 Hedge Errors
 */

enum HedgeError: Error {
    case invalidOrientation
}

/**
    HedgeFace
    numbered like die, in the final winning position
    next to the hole in the fence ready to roll over
    with the top face = one, north face = two
         ___
     ___|_3_|________
    |_2_|_1_|_5_|_6_|
        |_4_|
 
 
         |3|3|
         | | |
         |3|3|
 |2| |2| |1|1| |5| |5| |6|6|
 |2|2|2| |1|1| |5|5|5| |6|6|
         |4|4|
         |4|4|
         |4|4|
 
 */
enum HedgeFace : Int
{
    case one = 1 //square
    case two //smile
    case three //bench
    case four //flatback
    case five //smile
    case six //square
}

extension HedgeFace
{
    /**
     sides from top in clockwise order
     */
    func sides() -> [HedgeFace]
    {
        let top = self
        switch top {
        case .one:   return [.two, .three, .five, .four]
        case .two:   return [.one, .four, .six, .three]
        case .three: return [.one, .two, .six, .five]
        case .four:  return [.one, .five, .six, .two]
        case .five:  return [.one, .three, .six, .four]
        case .six:   return [.two, .four, .five, .three]
        }
    }
    /*
     get opposite of any side
     should be 7 - self.rawValue
     */
    func opposite() -> HedgeFace
    {
        switch self {
        case .one:   return .six
        case .two:   return .five
        case .three: return .four
        case .four:  return .three
        case .five:  return .two
        case .six:   return .one
        }
    }
}


enum Direction
{
    case north
    case south
    case east
    case west
    
    //dirty func because we can't iterate over directions
    static func all() -> [Direction]{
        return [.north, .south, .east, .west]
    }
}

struct Position
{
    var x: Int = 0
    var y: Int = 0
}

struct Orientation
{
    var top: HedgeFace = .one
    var north: HedgeFace = .two
}

struct Hedge
{
    var position: Position = Position()
    var orientation: Orientation = Orientation(top: .one, north: .two)
}

struct Board
{
    var start: Hedge = Hedge()
    var obstacles: Set<Position> = []
    var current: Hedge = Hedge()
    var winnableIn: Int = 0
    var turnCount: Int = 0
    var showSolution: Bool = true
}

