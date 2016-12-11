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
    private var path: PathView
    private var buttons: SKNode
    private var hedgeBlocks: [SKNode]
    private var obstacles: [SKNode]
    private weak var delegate: GameController?
    
    init(size: CGSize)
    {
        board = SKNode()
        buttons = SKNode()
        blockSize = floor((CGFloat(size.width) * 0.9) / CGFloat(GameProps.numCols))
        path = PathView(blockSize: blockSize)
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
        
        
        //draw the goal
        for pos in goal1.footPrint()
        {
            let ob = SKShapeNode(rectOf: CGSize(width: blockSize - 4, height: blockSize - 4), cornerRadius: 6)
            ob.fillColor = .purple
            ob.position = getPosition(for: pos)
            board.addChild(ob)
        }
        
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
        
        //path.position = CGPoint(x: boardSize.width/2, y: boardSize.height/2)
        board.addChild(path)
        
        //add the button container for easy button management
        board.addChild(buttons)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(
        board: Board,
        shortestPath: [Hedge],
        delegate: GameController)
    {
        self.delegate = delegate
        drawObstacles(board: board)
        drawButtons(current: board.current, obstacles: board.obstacles)
        path.draw(path: shortestPath.map{$0.position})
        moveHedge(to: board.current, duration: 0)
    }
    
    func update(board: Board, shortestPath: [Hedge])
    {
        drawButtons(current: board.current, obstacles: board.obstacles)
        path.draw(path: shortestPath.map{$0.position})
        moveHedge(to: board.current)
    }
    
    func displayWin()
    {
        print("display win!!!")
    }
    
    func somethingWentWrong(error: String)
    {
        print("something went wrong: \(error)")
    }
    
    private func drawButtons(current: Hedge, obstacles: Set<Position>)
    {
        buttons.removeAllChildren()
        let footprint = current.footPrint()
        for direction in Direction.all()
        {
            let rotated = try! current.rotate(to: direction)
            if rotated.isInBounds()
            {
                if obstacles.intersection(rotated.footPrint()).count == 0
                {
                    for pos in rotated.footPrint()
                    {
                        if !footprint.contains(pos)
                        {
                            let button = SimpleButton(
                                size: CGSize(width: blockSize - 4, height: blockSize - 4),
                                color: .green,
                                tapped: {
                                    [weak self] in
                                    self?.delegate?.move(to: direction)
                            })
                            button.alpha = 0
                            button.position = getPosition(for: pos)
                            let fadeIn = SKAction.fadeAlpha(to: 0.6, duration: 0.1)
                            button.run(fadeIn)
                            buttons.addChild(button)
                        }
                    }
                }
            }
        }
    }
    
    private func moveHedge(to hedge: Hedge, duration: Double = 0.2)
    {
        let footprint = hedge.footPrint()
        for (i, view) in hedgeBlocks.enumerated()
        {
            view.removeAllActions()
            if i < footprint.count
            {
                let group = SKAction.group([
                    SKAction.fadeAlpha(to: 1, duration: duration),
                    SKAction.move(to: getPosition(for: footprint[i]), duration: 0)
                ])
                view.run(group)
            }
            else
            {
                let group = SKAction.group([
                    SKAction.fadeAlpha(to: 0, duration: duration)
                ])
                view.run(group)
            }
        }
    }
    
    private func drawObstacles(board: Board)
    {
        for (i,obPosition) in board.obstacles.enumerated()
        {
            obstacles[i].position = getPosition(for: obPosition)
        }
    }
    
    private func getPosition(for pos: Position) -> CGPoint
    {
        return CGPoint(x: CGFloat(pos.x) * blockSize + blockSize/2, y: CGFloat(pos.y) * blockSize + blockSize/2 )
    }
}
