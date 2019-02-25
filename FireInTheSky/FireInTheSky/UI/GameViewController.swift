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
        scene = GameScene(size: view.frame.size, gameSceneDelegate: self)
        scene?.scaleMode = .aspectFill
        view.ignoresSiblingOrder = true
        //enableDebugIfNeeded(forView: view)
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



// MARK: - GameScene Delegate

extension GameViewController: GameSceneDelegate {
    
    func openGameMenu(isGameOver: Bool, completionHandler: @escaping () -> Void) {
        let controller = MenuViewController()
        controller.view.widthAnchor.constraint(equalToConstant: 200)
        controller.view.heightAnchor.constraint(equalToConstant: 200)
        controller.view.frame.size.width -= 50
        controller.view.frame.size.height -= 50
        controller.onReplayTapped = {
            controller.dismiss(animated: false, completion: completionHandler)
        }
        controller.modalPresentationStyle = .overCurrentContext
        controller.label.text = isGameOver ? "Game Over" : "Start Game"
        present(controller, animated: false, completion: nil)
    }
}
