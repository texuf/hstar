//
//  Tile+Extensions.swift
//  hstar
//
//  Created by Austin Ellis on 12/7/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation

extension Position: Hashable
{
    init(_ x: Int, _ y: Int)
    {
        self.init(x:x, y:y)
    }
    
    func isInBounds() -> Bool
    {
        return
            x >= 0 && x < GameProps.numCols
         && y >= 0 && y < GameProps.numRows
    }
    
    var hashValue : Int
    {
        get {
            //quick and dirty hash functions
            return "\(x)_\(y)".hashValue
        }
    }
    
    public static func ==(lhs: Position, rhs: Position) -> Bool
    {
        return lhs.hashValue == rhs.hashValue
    }
    
    public static func +(lhs: Position, rhs: Position) -> Position
    {
        return Position(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
    
    public static func +(lhs: Position, rhs: (Int, Int)) -> Position
    {
        return Position(
            x: lhs.x + rhs.0,
            y: lhs.y + rhs.1
        )
    }
}
