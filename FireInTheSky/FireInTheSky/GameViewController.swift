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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        guard let view = self.view as? SKView else {
            return
        }
        scene = GameScene(size: view.frame.size)
        scene?.scaleMode = .aspectFill
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.presentScene(scene!)
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let loc = sender.location(in: view)
        loc.x < view.frame.midX ? scene?.move(.left) : scene?.move(.right)
    }
}
