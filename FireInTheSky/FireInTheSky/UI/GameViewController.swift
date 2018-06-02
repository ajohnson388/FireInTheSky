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
    
    func restartGameScene() {
        guard let view = self.view as? SKView else {
            return
        }
        scene = GameScene(size: view.frame.size)
        scene?.gameSceneDelegate = self
        scene?.scaleMode = .aspectFill
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.presentScene(scene!)
    }
}



// MARK: - GameScene Delegate

extension GameViewController: GameSceneDelegate {
    
    func openGameMenu(completionHandler: @escaping () -> Void) {
        let controller = MenuViewController()
        controller.view.widthAnchor.constraint(equalToConstant: 200)
        controller.view.heightAnchor.constraint(equalToConstant: 200)
        controller.view.frame.size.width -= 50
        controller.view.frame.size.height -= 50
        controller.onReplayTapped = { [weak self] in
            self?.restartGameScene()
            controller.dismiss(animated: true, completion: completionHandler)
        }
        controller.modalPresentationStyle = .overCurrentContext
        controller.label.text = "Game Over"
        present(controller, animated: true, completion: nil)
    }
}
