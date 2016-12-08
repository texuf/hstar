//
//  Hedge+Ext.swift
//  hstar
//
//  Created by Austin Ellis on 12/7/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation

extension Hedge: Hashable
{
    var hashValue : Int{
        get {
            //very quick and dirty straitforward hash
            return "\(position.hashValue)_\(orientation.hashValue)".hashValue
        }
    }
    
    public static func ==(lhs: Hedge, rhs: Hedge) -> Bool
    {
        return lhs.hashValue == rhs.hashValue
    }
    
}

extension Hedge
{
    func isOutOfBounds() -> Bool {
        for position in footPrint(){
            if position.isOutOfBounds(){
                return true
            }
        }
        return false
    }
    
    func footPrint() -> [Position]
    {
        return orientation.footPrint().map{ position + $0 }
    }
    
    func rotate(to direction: Direction) throws -> Hedge
    {
        //do {
            let toOrientation = try orientation.rotate(to: direction)
            let translation = getTranslation(to: direction, toOrientation: toOrientation)
            return Hedge(
                position: position + translation,
                orientation: toOrientation
            )
        //}
        //catch{
        //    return nil
        //}
    }
    
    private func getTranslation(to direction: Direction, toOrientation: Orientation) -> Position
    {
        switch direction {
            case .north:
                return Position(
                    x: 0,
                    y: orientation.size().height)
            case .east:
                return Position(
                    x: orientation.size().width,
                    y: 0)
            case .west:
                return Position(
                    x: -toOrientation.size().width,
                    y: 0)
            case .south:
                return Position(
                    x: 0,
                    y: -toOrientation.size().height)
        }
    }
    
}
