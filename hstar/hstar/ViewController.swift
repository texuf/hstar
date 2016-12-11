//
//  ViewController.swift
//  hstar
//
//  Created by Austin Ellis on 12/6/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import UIKit
import SpriteKit


class ViewController: UIViewController {

    
    var skView:SKView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene = GameScene(size: view.frame.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .white
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

