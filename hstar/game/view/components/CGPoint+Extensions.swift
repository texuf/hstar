//
//  CGPoint+Extensions.swift
//  hstar
//
//  Created by Austin Ellis on 12/10/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation
import SpriteKit

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 * Increments a CGPoint with the value of another.
 */
public func += ( left: inout CGPoint, right: CGPoint) {
    left = left + right
}


/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value.
 */
public func *= ( point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}


/**
 * Multiplies the x and y fields of a CGSize with the same scalar value and
 * returns the result as a new CGPoint.
 */
public func * (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width * scalar, height: size.height * scalar)
}

/**
 * Multiplies the x and y fields of a CGSize with the same scalar value.
 */
public func *= ( size: inout CGSize, scalar: CGFloat) {
    size = size * scalar
}
