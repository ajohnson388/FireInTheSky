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
    
    static func makeFireDrop(withSize size: CGSize, at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(color: .red, size: size)
        sprite.position = position
        sprite.texture = SKTexture(imageNamed: "fire")
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.contactTestBitMask = PhysicsBitMask.player.rawValue
        sprite.physicsBody?.categoryBitMask = PhysicsBitMask.fire.rawValue
        sprite.physicsBody?.collisionBitMask = PhysicsBitMask.none.rawValue
        return sprite
    }
    
    static func makePlayer(withSize size: CGSize, at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(color: .green, size: size)
        sprite.position = position
        sprite.texture = SKTexture(imageNamed: "player_left")
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.contactTestBitMask = PhysicsBitMask.fire.rawValue
        sprite.physicsBody?.categoryBitMask = PhysicsBitMask.player.rawValue
        sprite.physicsBody?.collisionBitMask = PhysicsBitMask.ground.rawValue
        sprite.physicsBody?.friction = 0
        return sprite
    }
    
    static func makeFireDropShadow(withSize size: CGSize, at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(color: .black, size: size)
        sprite.position = position
        sprite.zPosition = 10
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.contactTestBitMask = PhysicsBitMask.none.rawValue
        sprite.physicsBody?.categoryBitMask = PhysicsBitMask.shadow.rawValue
        sprite.physicsBody?.collisionBitMask = PhysicsBitMask.none.rawValue
        return sprite
    }
    
    static func makeGround(withSize size: CGSize, at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(color: .brown, size: size)
        sprite.position = position
        sprite.texture = SKTexture(imageNamed: "ground")
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = PhysicsBitMask.ground.rawValue
        sprite.physicsBody?.collisionBitMask = PhysicsBitMask.player.rawValue
        return sprite
    }
}
