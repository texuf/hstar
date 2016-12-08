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
let numCols = 7
let numRows = 7

/*var winCondition: HedgePosition = HedgePosition(
    tile: Tile(x: 6, y: 3),
    topFace: .one,
    northFace: .two
)*/

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
    
    func sides() -> [HedgeFace]
    {
        switch self {
            case .one:   return [.two, .three, .five, .four]
            case .two:   return [.one, .four, .six, .three]
            case .three: return [.one, .two, .six, .five]
            case .four:  return [.one, .five, .six, .two]
            case .five:  return [.one, .three, .six, .four]
            case .six:   return [.two, .four, .five, .three]
        }
    }
    
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

/*enum HedgeShape
{
    case square
    case smile
    case bench
    case flatback
}

enum HedgeRotation
{
    case zero
    case ninety
    case oneeighty
    case twoseventy
}*/

enum Direction
{
    case north
    case south
    case east
    case west
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

