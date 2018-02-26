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
    
    // MARK: - Properties
    
    typealias FireDrop = (droplet: SKSpriteNode, shadow: SKSpriteNode)
    
    var fireDrops = [FireDrop]()
    var deltaClock: TimeInterval = 0
    
    var ground = SKSpriteNode()
    var player = SKSpriteNode()
    
    let moveGesture = UITapGestureRecognizer(target: nil, action: nil)
    
    let fireTexture = SKTexture(imageNamed: "fire")
    let fireShadowTexture = SKTexture(imageNamed: "fire_shadow")
    
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        moveGesture.addTarget(self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(moveGesture)
        setupBackground()
        setupGround()
        setupPlayer()
        move(inDirection: .left)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (deltaClock > 1e5) {
            deltaClock = 0
            let randomX = arc4random_uniform(UInt32.init(frame.size.width))
            addFireDrop(at: CGFloat.init(randomX))
        }
        deltaClock += currentTime
    }
    
    override func didSimulatePhysics() {
        let fireDroplets = fireDrops
        let range = 0..<fireDroplets.count
        for i in range {
            let drops = fireDroplets[i]
            let refY = ground.frame.maxY + drops.droplet.size.height + 30
            let currentY = drops.droplet.position.y
            let deltaY = currentY - refY
            print(deltaY)
            if deltaY > 0 {
                drops.shadow.size.width = deltaY * 0.2
            } else {
                drops.droplet.removeFromParent()
                drops.shadow.removeFromParent()
                fireDrops.remove(at: i)
            }
        }
    }
}


// MARK: - Interactions

extension GameScene {
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let direction = (player.physicsBody?.velocity.dx ?? 0) > 0
            ? PlayerDirection.left : .right
        move(inDirection: direction)
    }
    
    func move(inDirection direction: PlayerDirection) {
        let velocity = CGVector(dx: 100 * direction.rawValue, dy: 0)
        player.physicsBody?.velocity = velocity
        player.texture = SKTexture(imageNamed: direction.imageName)
    }
}


// MARK: - Setup

extension GameScene {
 
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
        if ground.frame.contains(CGPoint(x: x, y: ground.frame.midY)) {
            let shadow = makeFireShadow(at: x)
            addChild(shadow)
            let drops = FireDrop(droplet: fireDrop, shadow: shadow)
            fireDrops.append(drops)
        }
    }
    
    func makeFireShadow(at x: CGFloat) -> SKSpriteNode {
        let size = CGSize(width: 10, height: 10)
        let position = CGPoint(x: x, y: frame.size.height/2)
        let fireDrop = SKSpriteNode(texture: fireShadowTexture, color: .red, size: size)
        fireDrop.zPosition = 10
        fireDrop.position = position
        fireDrop.physicsBody = SKPhysicsBody(rectangleOf: size)
        fireDrop.physicsBody?.affectedByGravity = true
        fireDrop.physicsBody?.isDynamic = false
        fireDrop.physicsBody?.contactTestBitMask = PhysicsBitMask.none.rawValue
        fireDrop.physicsBody?.categoryBitMask = PhysicsBitMask.shadow.rawValue
        fireDrop.physicsBody?.collisionBitMask = PhysicsBitMask.none.rawValue
        return fireDrop
    }
}
