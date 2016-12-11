//
//  GameController.swift
//  hstar
//
//  Created by Austin Ellis on 12/8/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation


class GameController
{
    enum GameControllerError: Error
    {
        case randomStartTimedOut
    }
    
    private var view: GameView
    private var board: Board
    
    init(view: GameView)
    {
        self.view = view
        self.board = Board()
    }
    
    func startNewGame()
    {
        do{
            let (start, obstacles, path) = try GameController.generateRandomStart()
            board = Board(
                start: start,
                obstacles: obstacles,
                current: start,
                winnableIn: path.count,
                turnCount: 0,
                showSolution: board.showSolution)
            view.initialize(
                board: board,
                shortestPath: path,
                delegate: self)
        }
        catch let error as NSError
        {
            // a reboot is currently necessary
            view.somethingWentWrong(error: String(describing: error))
        }
    }
    
    func toggleSolution()
    {
        board.showSolution = !board.showSolution
        renderBoard()
    }
    
    func restartCurrentGame()
    {
        board.current = board.start
        renderBoard()
    }
    
    func move(to direction: Direction)
    {
        do{
            board.turnCount += 1
            board.current = try board.current.rotate(to: direction)
            renderBoard()
        }
        catch{
            print("error rotating hedge")
        }
        
    }
    
    private func renderBoard()
    {
        do{
            let path = try HStar.shortestPath(from: board.current, obstacles: board.obstacles)
            view.update(board: board, shortestPath: path)
            if path.count == 1
            {
                view.displayWin()
            }
        }
        catch{
            print("error finding path")
        }
    }
    
    static func generateRandomStart() throws -> (start: Hedge, obstacles: Set<Position>, path: [Hedge])
    {
        //limit number of tries so we don't run forever
        let limit = 10000
        var count = 0
        while count < limit
        {
            count += 1
            //randomly pick top
            let top = HedgeFace(rawValue: Int(arc4random_uniform(6)) + 1)!
            //randomly pick north from top's sides
            let orientation = Orientation(
                top: top,
                north: top.sides()[Int(arc4random_uniform(UInt32(top.sides().count)))])
            //randomly pick position
            let start = Hedge(
                position: Position(
                    x: Int(arc4random_uniform(UInt32(GameProps.numCols - orientation.size().width))),
                    y: Int(arc4random_uniform(UInt32(GameProps.numRows - orientation.size().height)))
                ),
                orientation: orientation)
            if start.isInBounds(){
                //randomly pick obstacles if obstacle not in footprint
                //check to see if there's a solution
                let footprint = start.footPrint()
                var obstacles = Set<Position>()
                while obstacles.count < GameProps.numObstacles {
                    let ob = Position(
                        x: Int(arc4random_uniform(UInt32(GameProps.numCols))),
                        y: Int(arc4random_uniform(UInt32(GameProps.numRows)))
                    )
                    if !footprint.contains(ob)
                    {
                        obstacles.insert(ob)
                    }
                }
                let path = try HStar.shortestPath(from: start, obstacles: obstacles)
                if path.count > 1
                {
                    return (
                        start: start,
                        obstacles: obstacles,
                        path: path
                    )
                }
            }
        }
        throw GameControllerError.randomStartTimedOut
    }
    
}
