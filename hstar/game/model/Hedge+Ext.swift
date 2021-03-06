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
    func isInBounds() -> Bool {
        for position in footPrint(){
            if !position.isInBounds(){
                return false
            }
        }
        return true
    }
    
    func footPrint() -> [Position]
    {
        return orientation.footPrint().map{ position + $0 }
    }
    
    func rotate(to direction: Direction) throws -> Hedge
    {
        let toOrientation = try orientation.rotate(to: direction)
        let translation = getTranslation(to: direction, toOrientation: toOrientation)
        return Hedge(
            position: position + translation,
            orientation: toOrientation
        )
    }
    
    private func getTranslation(to direction: Direction, toOrientation: Orientation) -> Position
    {
        switch direction {
            case .north:
                return Position(
                    x: 0,
                    y: orientation.size().height - 1)
            case .east:
                return Position(
                    x: orientation.size().width - 1,
                    y: 0)
            case .west:
                return Position(
                    x: -toOrientation.size().width + 1,
                    y: 0)
            case .south:
                return Position(
                    x: 0,
                    y: -toOrientation.size().height + 1)
        }
    }
    
}
