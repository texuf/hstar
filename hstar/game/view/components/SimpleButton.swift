//
//  SimpleButton.swift
//  hstar
//
//  Created by Austin Ellis on 12/10/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation
import SpriteKit

class SimpleButton: SKSpriteNode {
    private var tapped: () -> ()
    
    init(size: CGSize, color: UIColor, tapped: @escaping () -> ()) {
        self.tapped = tapped
        super.init(texture: nil, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let parent = parent {
                let location = touch.location(in: parent)
                if contains(location) {
                    tapped()
                    break
                }
            }
        }
    }
}
