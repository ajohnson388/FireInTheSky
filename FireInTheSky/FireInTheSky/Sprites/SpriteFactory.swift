//
//  SpriteFactory.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/26/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

struct SpriteFactory {
    
    static func makeGround(withSize size: CGSize, at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(color: .clear, size: size)
        sprite.name = Node.ground.rawValue
        sprite.position = position
        sprite.texture = SKTexture(imageNamed: "ground")
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = PhysicsBitMask.ground.rawValue
        sprite.physicsBody?.collisionBitMask = PhysicsBitMask.player.rawValue
        return sprite
    }
    
    static func makeLava(withSize size: CGSize, at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(color: .blue, size: size)
        sprite.name = Node.lava.rawValue
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = PhysicsBitMask.lava.rawValue
        sprite.physicsBody?.collisionBitMask = PhysicsBitMask.player.rawValue
        return sprite
    }
}
