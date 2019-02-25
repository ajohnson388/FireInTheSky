//
//  GameViewController.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/25/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        restartGameScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func restartGameScene() {
        guard let view = self.view as? SKView else {
            return
        }
        enableDebugIfNeeded(forView: view)
        scene = GameScene(size: view.frame.size)
        scene?.scaleMode = .aspectFill
        view.ignoresSiblingOrder = true
        view.presentScene(scene!)
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    private func enableDebugIfNeeded(forView view: SKView) {
        #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        #endif
    }
}
