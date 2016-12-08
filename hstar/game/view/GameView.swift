//
//  GameView.swift
//  hstar
//
//  Created by Austin Ellis on 12/8/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation
import SpriteKit

class GameView: SKNode
{
    /**
     put together in a bit of a hurry, 
     so not commented super well
 */
    private var blockSize: CGFloat
    private var board: SKNode
    private var hedgeBlocks: [SKNode]
    private var obstacles: [SKNode]
    
    init(size: CGSize)
    {
        board = SKNode()
        blockSize = floor((CGFloat(size.width) * 0.9) / CGFloat(GameProps.numCols))
        hedgeBlocks = [SKNode]()
        obstacles = [SKNode]()
        super.init()
        
        //create a board node to hold all the board elements
        let boardSize = CGSize(width: blockSize * CGFloat(GameProps.numCols), height: blockSize * CGFloat(GameProps.numRows))
        board.position = CGPoint(x: size.width/2 - boardSize.width/2, y: size.height/2 - boardSize.height/2)
        addChild(board)
        
        //draw a grid
        let grid = GridView(blockSize: blockSize, rows: GameProps.numRows, cols: GameProps.numCols)
        grid.position = CGPoint(x: boardSize.width/2, y: boardSize.height/2)
        board.addChild(grid)
        
        //initialize obstacles
        for _ in 0..<GameProps.numObstacles
        {
            let ob = SKShapeNode(circleOfRadius: blockSize * 0.45)
            ob.fillColor = .red
            board.addChild(ob)
            obstacles.append(ob)
        }
        
        //initialize hedge
        for _ in 0..<GameProps.hedgeFootprintSize
        {
            let h = SKShapeNode(rectOf: CGSize(width: blockSize, height: blockSize), cornerRadius: 4)
            h.fillColor = .brown
            board.addChild(h)
            hedgeBlocks.append(h)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
