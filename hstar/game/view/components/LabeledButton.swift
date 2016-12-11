//
//  LabeledButton.swift
//  hstar
//
//  Created by Austin Ellis on 12/10/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation
import SpriteKit


class LabeledButton: SimpleButton {
    var label: SKLabelNode
    init(text: String, fontSize: CGFloat, size: CGSize, color: UIColor, tapped: @escaping () -> ()) {
        label = SKLabelNode()
        super.init(size: size, color: color, tapped: tapped)
        
        label.text = text
        label.fontName = GameProps.font
        label.fontSize = fontSize
        label.color = .white
        label.verticalAlignmentMode = .center
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
