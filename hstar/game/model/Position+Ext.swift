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
    
    func toIndex() -> Int
    {
        return y * numCols + x
    }
    
    func isOutOfBounds() -> Bool
    {
        return
            x < 0 || x >= numCols
         || y < 0 || y >= numRows
    }
    
    var hashValue : Int
    {
        get {
            return toIndex()
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
