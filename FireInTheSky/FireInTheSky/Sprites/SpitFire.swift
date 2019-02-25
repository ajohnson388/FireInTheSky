//
//  SpitFire.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 9/2/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

final class SpitFire: SKSpriteNode {
    
    init(size: CGSize, position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "fire"), color: .red, size: size)
        self.position = position
        setupSprite()
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSprite() {
        name = Node.fireDrop.rawValue
        
        let fileName = "FireDrop.sks"
        if let particleEmiiter = SKEmitterNode(fileNamed: fileName) {
            particleEmiiter.particlePositionRange = CGVector(dx: size.width, dy: size.height)
            particleEmiiter.targetNode = self
            addChild(particleEmiiter)
        } else {
            print("Failed to load file \(fileName)")
        }
    }
    
    private func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.contactTestBitMask = PhysicsBitMask.player.rawValue
            | PhysicsBitMask.ground.rawValue | PhysicsBitMask.lava.rawValue
        physicsBody?.categoryBitMask = PhysicsBitMask.fire.rawValue
        physicsBody?.collisionBitMask = PhysicsBitMask.none.rawValue
    }
}
