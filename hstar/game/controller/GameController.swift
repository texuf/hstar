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
    enum GameControllerError: String
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
            let (start, obstacles, path) = GameController.generateRandomStart()
            board = Board(
                start: start,
                obstacles: obstacles,
                current: start,
                winnableIn: path.count,
                turnCount: 0)
            view.initialize(
                board: board,
                shortestPath: path,
                onMove: {
                    [unowned self]
                    (_ direction: Direction) in
                    self.move(to: direction)
            })
        }
        catch let error as GameControllerError
        {
            print(error)
        }
    }
    
    func move(to direction: Direction)
    {
        board.current = board.current.rotate(to: direction)
        let path = HStar.shortestPath(from: board.current, obstacles: board.obstacles)
        view.update(board: board, shortestPath: path)
        if path.count
    }
    
    static func generateRandomStart() throws -> (start: Hedge, obstacles: Set<Position>, path: [Hedge])
    {
        //limit number of ties so we don't run forever
        let limit = 10000
        var count = 0
        while count < limit
        {
            count += 1
            //randomly pick top
            //randomly pick north from top's sides
            //randomly pick position
            //randomly pick obstacles if obstacle not in footprint
            //check to see if there's a solution
        }
        throw GameControllerError.randomStartTimedOut
    }
    
}
