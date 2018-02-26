//
//  GameScene.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/25/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    enum PhysicsBitMask: UInt32 {
        case none, ground, player, fire, all
    }
    
    enum Direction: Int {
        case left = -1
        case right = 1
        
        var imageName: String {
            switch self {
            case .left: return "player_left"
            case .right: return "player_right"
            }
        }
    }
    
    var deltaClock: TimeInterval = 0
    
    var ground = SKSpriteNode()
    var player = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        // Setup view
        setupBackground()
        setupGround()
        setupPlayer()
        move(.left)
    }
    
    func setupWorldPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.9)
    }
    
    func setupBackground() {
        let bg = SKSpriteNode(texture: SKTexture(imageNamed: "bg"), color: .blue, size: frame.size)
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.zPosition = -3
        addChild(bg)
    }
    
    func setupGround() {
        let size = CGSize(width: frame.size.width/1.5, height: frame.size.height/2)
        let position = CGPoint(x: frame.size.width/2, y: size.height/2)
        ground.texture = SKTexture(imageNamed: "ground")
        ground.size = size
        ground.position = position
        ground.color = UIColor.brown
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsBitMask.ground.rawValue
        ground.physicsBody?.collisionBitMask = PhysicsBitMask.player.rawValue
        
        addChild(ground)
    }
    
    func setupPlayer() {
        let size = CGSize(width: 50, height: 50)
        let position = CGPoint(x: ground.frame.midX, y: ground.frame.maxY + size.height)
        player.size = size
        player.position = position
        player.color = UIColor.green
        
        player.physicsBody = SKPhysicsBody(rectangleOf: size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.contactTestBitMask = PhysicsBitMask.fire.rawValue
        player.physicsBody?.categoryBitMask = PhysicsBitMask.player.rawValue
        player.physicsBody?.collisionBitMask = PhysicsBitMask.ground.rawValue
        player.physicsBody?.friction = 0
        
        addChild(player)
    }
    
    func move(_ direction: Direction) {
        let velocity = CGVector(dx: 100 * direction.rawValue, dy: 0)
        player.physicsBody?.velocity = velocity
        player.texture = SKTexture(imageNamed: direction.imageName)
    }
    
    
    let fireTexture = SKTexture(imageNamed: "fire")
    
    func addFireDrop(at x: CGFloat) {
        let size = CGSize(width: 10, height: 10)
        let position = CGPoint(x: x, y: frame.size.height)
        let fireDrop = SKSpriteNode(texture: fireTexture, color: .red, size: size)
        fireDrop.position = position
        fireDrop.physicsBody = SKPhysicsBody(rectangleOf: size)
        fireDrop.physicsBody?.affectedByGravity = true
        fireDrop.physicsBody?.contactTestBitMask = PhysicsBitMask.player.rawValue
        fireDrop.physicsBody?.categoryBitMask = PhysicsBitMask.fire.rawValue
        fireDrop.physicsBody?.collisionBitMask = PhysicsBitMask.none.rawValue
        addChild(fireDrop)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if (deltaClock > 1e5) {
            deltaClock = 0
            let randomX = arc4random_uniform(UInt32.init(frame.size.width))
            addFireDrop(at: CGFloat.init(randomX))
        }
        deltaClock += currentTime
    }
}
