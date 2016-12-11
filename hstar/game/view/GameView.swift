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
    private var menuButtonSize: CGSize
    private var menuStartPosition: CGPoint
    private var board: SKNode
    private var path: PathView
    private var buttons: SKNode
    private var hedgeBlocks: [SKNode]
    private var obstacles: [SKNode]
    private var menu: [(condition: (Board) -> Bool, button: LabeledButton)] = []
    private weak var delegate: GameController?
    
    init(size: CGSize)
    {
        blockSize = floor((CGFloat(size.width) * 0.9) / CGFloat(GameProps.numCols))
        let boardSize = CGSize(width: blockSize * CGFloat(GameProps.numCols), height: blockSize * CGFloat(GameProps.numRows))
        board = SKNode()
        buttons = SKNode()
        menuButtonSize = CGSize(width: size.width/2, height: blockSize * 0.9)
        menuStartPosition = CGPoint(x: size.width/2, y: size.height/2 - boardSize.height/2 - menuButtonSize.height)
        path = PathView(blockSize: blockSize)
        path.alpha = 0.2
        hedgeBlocks = [SKNode]()
        obstacles = [SKNode]()
        super.init()
        
        //create a board node to hold all the board elements
        
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
        
        //make the main menu buttons
        makeMainMenu()
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
        drawButtons(board: board, shortestPath: shortestPath)
        path.draw(board: board, shortestPath: shortestPath)
        moveHedge(to: board.current, duration: 0)
        displayMenu(board: board)
    }
    
    func update(board: Board, shortestPath: [Hedge])
    {
        drawButtons(board: board, shortestPath: shortestPath)
        path.draw(board: board, shortestPath: shortestPath)
        moveHedge(to: board.current)
        displayMenu(board: board)
    }
    
    func displayWin()
    {
        print("display win!!!")
    }
    
    func somethingWentWrong(error: String)
    {
        print("something went wrong: \(error)")
    }
    
    private func drawButtons(board: Board, shortestPath: [Hedge])
    {
        let current = board.current
        let nextHedge: Hedge? = shortestPath.count > 1 ? shortestPath[1] : nil
        buttons.removeAllChildren()
        let footprint = current.footPrint()
        for direction in Direction.all()
        {
            let rotated = try! current.rotate(to: direction)
            if rotated.isInBounds()
            {
                if board.obstacles.intersection(rotated.footPrint()).count == 0
                {
                    for pos in rotated.footPrint()
                    {
                        if !footprint.contains(pos)
                        {
                            let hintedAlpha: CGFloat = (rotated == nextHedge) ? 0.7 : 0.2
                            let buttonAlpha: CGFloat = board.showSolution
                                ? hintedAlpha
                                : 0.6
                            
                            let button = SimpleButton(
                                size: CGSize(width: blockSize - 4, height: blockSize - 4),
                                color: .green,
                                tapped: {
                                    [weak self] in
                                    self?.delegate?.move(to: direction)
                            })
                            button.alpha = 0
                            button.position = getPosition(for: pos)
                            let fadeIn = SKAction.fadeAlpha(to: buttonAlpha, duration: 0.1)
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
    
    private func displayMenu(board: Board)
    {
        var yDiff: CGFloat = 0
        for kv in menu{
            if kv.condition(board)
            {
                kv.button.isHidden = false
                kv.button.position = menuStartPosition + CGPoint(x: 0, y: yDiff)
                yDiff -= menuButtonSize.height * 1.1
            }
            else
            {
                kv.button.isHidden = true
            }
        }
    }
    
    private func makeMainMenu()
    {
        let buttonColor = UIColor.blue
        let omenu: [(String, (Board) -> Bool, () -> Void)] = [
            ("Show Hints", {$0.showSolution == false}, {[weak self] in self?.delegate?.toggleSolution() }),
            ("Hide Hints", {$0.showSolution == true}, {[weak self] in self?.delegate?.toggleSolution() }),
            ("Restart Game", {_ in return true}, {[weak self] in self?.delegate?.restartCurrentGame()} ),
            ("New Game", {_ in return true}, {[weak self] in self?.delegate?.startNewGame()} ),
        ]
        
        let fontSize = ViewHelpers.findFontSize(for: "Show Solution", fontName: GameProps.font, maxFontSize: 50, minFontSize: 10, bounds: menuButtonSize * 0.9)
        
        for item in omenu{
            let button = LabeledButton(text: item.0, fontSize: fontSize, size: menuButtonSize, color: buttonColor, tapped: item.2)
            menu.append(
                condition: item.1,
                button: button
            )
            addChild(button)
            button.isHidden = true
        }
    }
    
    private func getPosition(for pos: Position) -> CGPoint
    {
        return CGPoint(x: CGFloat(pos.x) * blockSize + blockSize/2, y: CGFloat(pos.y) * blockSize + blockSize/2 )
    }
}

