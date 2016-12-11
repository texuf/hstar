//
//  PathView.swift
//  hstar
//
//  Created by Austin Ellis on 12/10/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation
import SpriteKit

class PathView : SKShapeNode {
    
    private var blockSize:CGFloat = 1
    private var labels: [SKLabelNode] = []
    private var start: SKShapeNode
    let color = UIColor.blue
    init(blockSize:CGFloat) {
        start = SKShapeNode(circleOfRadius: blockSize/9)
        super.init()
        self.blockSize = blockSize
        start.fillColor = color
        start.strokeColor = .gray
        addChild(start)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(path: [Position])
    {
        self.isHidden = false
        
        for label in labels{
            label.removeFromParent()
        }
        labels.removeAll()
        
        var mPath = CGMutablePath()
        var reached: [Position: Int] = [:]
        
        func makePoint(_ pos: Position, yMod: CGFloat) -> CGPoint
        {
            return CGPoint(x: CGFloat(pos.x) * blockSize + blockSize/2, y: CGFloat(pos.y) * blockSize + blockSize/2 + yMod )
        }
        
        if path.count > 0{
            var from = makePoint(path[0], yMod: 0)
            start.position = from
            for i in 1..<path.count
            {
                let pos = path[i]
                let yMod = (reached[pos] != nil) ? reached[pos]! * 15 : 0
                reached[pos] = (reached[pos] != nil) ? reached[pos]! + 1 : 1
                let to = makePoint(pos, yMod: CGFloat(yMod))
                mPath.move(to: from)
                mPath.addLine(to: to)
                
                
                let label = SKLabelNode(text: String(path.count - i))
                label.fontSize = 14
                label.position = to
                label.horizontalAlignmentMode = .center
                label.verticalAlignmentMode = .center
                label.fontColor = .black
                label.fontName = "helvetica"
                addChild(label)
                labels.append(label)
                
                from = to
            }
        }
        else {
            self.isHidden = true
        }
        self.path = mPath
        self.strokeColor = color
        self.lineWidth = 1
    }
    
    func clear()
    {
        self.isHidden = true
    }
}
