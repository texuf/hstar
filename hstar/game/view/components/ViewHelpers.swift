//
//  ViewHelpers.swift
//  hstar
//
//  Created by Austin Ellis on 12/10/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation
import SpriteKit

class ViewHelpers
{
    
    static func findFontSize(for string: String, fontName: String, maxFontSize: CGFloat, minFontSize: CGFloat, bounds: CGSize) -> CGFloat
    {
        let half = maxFontSize - round((maxFontSize - minFontSize) / 2)
        let font = UIFont(name: fontName, size: half)
        let textAttributes:[String: AnyObject] = [NSFontAttributeName: font!]
        let stringSize = string.size(attributes: textAttributes)
        
        if half == maxFontSize || half == minFontSize
        {
            return half
        }
        
        let maxWidth = bounds.width
        let maxHeight = bounds.height
        if stringSize.width > maxWidth || stringSize.height > maxHeight
        {
            return findFontSize(for: string, fontName: fontName, maxFontSize: half, minFontSize: minFontSize, bounds: bounds )
        }
        else
        {
            return findFontSize(for: string, fontName: fontName, maxFontSize: maxFontSize, minFontSize: half, bounds: bounds)
        }
    }
    
}
