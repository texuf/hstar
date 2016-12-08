//
//  GameScene.swift
//  hstar
//
//  Created by Austin Ellis on 12/8/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to: SKView) {
        //        Logger.info("did move to: \(to)")
        
        
        removeAllChildren()
        let gameView = GameView(size: self.frame.size)
        //self.gameView = gameView
        addChild(gameView)
        
        let gameController = GameController(view: gameView)
        //self.gameController = gameController
        gameController.startNewGame()
        
        
    }
    
}
