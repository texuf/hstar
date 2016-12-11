//
//  Orientation+Extensions.swift
//  hstar
//
//  Created by Austin Ellis on 12/7/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation

extension Orientation: Hashable
{
    var hashValue : Int{
        get {
            //very quick and dirty straitforward hash
            return "\(north.rawValue)_\(top.rawValue)".hashValue
        }
    }
    
    public static func ==(lhs: Orientation, rhs: Orientation) -> Bool
    {
        return lhs.top == rhs.top
            && lhs.north == rhs.north
    }
}

extension Orientation
{
    func rotate(to direction: Direction ) throws -> Orientation
    {
        switch direction {
            case .north:
                return Orientation(
                    top: south(),
                    north: top
                )
            case .south:
                return Orientation(
                    top: north,
                    north: bottom()
                )
            case .east:
                return Orientation(
                    top: try west(),
                    north: north
                )
            case .west:
                return Orientation(
                    top: try east(),
                    north: north
                )
        }
    }
    
    func size()  -> (width: Int, height: Int)
    {
        if top == .one || top == .six{
            return (width: hDepth, height: hDepth)
        }
        else if north == .one || north == .six{
            return (width: hDepth, height: hLength)
        }
        else{
            return (width: hLength, height: hDepth)
        }
    }
    
    func footPrint() -> [(Int, Int)]
    {
        switch top {
        case .one:
            return [
                (0,1), (1,1),
                (0,0), (1,0)
            ]
        case .six:
            return [
                (0,1), (1,1),
                (0,0), (1,0)
            ]
        case .three:
            return size().width > size().height
                ? [
                    (0,1), (1,1), (2,1),
                    (0,0), (1,0), (2,0)
                ]
                : [
                    (0,2), (1,2),
                    (0,1), (1,1),
                    (0,0), (1,0)
    
                ]
        case .four:
            return size().width > size().height
                ? [
                    (0, 1), /*gap*/ (2, 1),
                    (0, 0), /*gap*/ (2, 0)
                ]
                : [
                    (0, 2), (1, 2),
                    /*gap*/ /*gap*/
                    (0, 0), (1, 0),
                ]
        case .five:
            return size().width > size().height
                ? north == .three
                    ? [
                        (0, 1), /*gap*/ (2, 1),
                        (0, 0), (1, 1), (2, 0)
                    ]
                    : [
                        (0, 1), (1, 1), (2, 1),
                        (0, 0), /*gap*/ (2, 0)
                    ]
                : north == .one
                    ? [
                        (0, 2), (1, 2),
                        (0, 1), /*gap*/
                        (0, 0), (1, 0),
                    ]
                    : [
                        (0, 2), (1, 2),
                        /*gap*/ (1, 1),
                        (0, 0), (1, 0),
                    ]
        case .two:
            return size().width > size().height
                ? north == .three
                    ? [
                        (0, 1), /*gap*/ (2, 1),
                        (0, 0), (1, 1), (2, 0)
                    ]
                    : [
                        (0, 1), (1, 1), (2, 1),
                        (0, 0), /*gap*/ (2, 0)
                    ]
                : north == .one
                    ? [
                        (0, 2), (1, 2),
                        /*gap*/ (1, 1),
                        (0, 0), (1, 0),
                    ]
                    : [
                        (0, 2), (1, 2),
                        (0, 1), /*gap*/
                        (0, 0), (1, 0),
                    ]

        }
    }
    
    private func bottom() -> HedgeFace
    {
        return top.opposite()
    }
    
    private func south() -> HedgeFace
    {
        return north.opposite()
    }
    
    private func east() throws -> HedgeFace
    {
        let sides = top.sides()
        if let sideIndex = sides.index(of: north)
        {
            return sides[ (sideIndex + 1) % sides.count]
        }
        throw HedgeError.invalidOrientation
    }
    
    private func west() throws -> HedgeFace
    {
        return (try east()).opposite()
    }
}
