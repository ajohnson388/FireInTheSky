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
    
    private let fireDropPeriod: TimeInterval = 1e4
    private var fireDropCounter: TimeInterval = 0
    
    private var fireDrops = [FireDrop]()
    private var ground: SKSpriteNode!
    private var player: SKSpriteNode!
    
    private let moveGesture = UITapGestureRecognizer(target: nil, action: nil)
    
    private let fireTexture = SKTexture(imageNamed: "fire")
    private let fireShadowTexture = SKTexture(imageNamed: "fire_shadow")
    
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        moveGesture.addTarget(self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(moveGesture)
        addBackground()
        addGround()
        addPlayer()
        move(inDirection: .left)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (fireDropCounter > fireDropPeriod) {
            fireDropCounter = 0
            addFireDrop()
        }
        fireDropCounter += currentTime
    }
    
    override func didSimulatePhysics() {
        let fireDrops = self.fireDrops
        fireDrops.forEach(updateFireDrop)
    }
}


// MARK: - Contact Delegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if hasContact(contact, with: .fire, .player) {
            // TODO: End game and animate death
        }
    }
    
    func hasContact(_ contact: SKPhysicsContact, with first: PhysicsBitMask, _ second: PhysicsBitMask) -> Bool {
        return (contact.bodyA.categoryBitMask == first.rawValue
            && contact.bodyB.categoryBitMask == second.rawValue)
            || (contact.bodyA.categoryBitMask == second.rawValue
                && contact.bodyB.categoryBitMask == first.rawValue)
    }
}


// MARK: - Fire Drops

private extension GameScene {
    
    func updateFireDrop(_ fireDrop: FireDrop) {
        let dropletY = fireDrop.droplet.position.y
        let groundDeltaY = dropletY - (ground.frame.maxY + fireDrop.droplet.size.height)
        let floorDeltaY = dropletY - (-1 * fireDrop.droplet.size.height)
        let shouldRemoveDrop = fireDrop.shadow == nil
            ? (floorDeltaY) <= 0
            : (groundDeltaY) <= 0
        if shouldRemoveDrop {
            removeFireDrop(fireDrop)
        } else if let shadow = fireDrop.shadow {
            shadow.size.width = groundDeltaY * 0.1
        }
    }
    
    func removeFireDrop(_ fireDrop: FireDrop) {
        fireDrop.droplet.removeFromParent()
        fireDrop.shadow?.removeFromParent()
        if let index = fireDrops.index(of: fireDrop) {
            fireDrops.remove(at: index)
        }
    }
    
    func addFireDrop() {
        let maxX = UInt32(frame.size.width)
        let randomX = arc4random_uniform(maxX)
        addFireDrop(at: CGFloat(randomX))
    }
    
    func addFireDrop(at x: CGFloat) {
        let size = CGSize(width: 10, height: 10)
        let position = CGPoint(x: x, y: frame.size.height)
        let fireDrop = SpriteFactory.makeFireDrop(withSize: size, at: position)
        addChild(fireDrop)
        
        if groundContains(x: x) {
            let shadow = makeFireShadow(at: x)
            addChild(shadow)
            let drops = FireDrop(droplet: fireDrop, shadow: shadow)
            fireDrops.append(drops)
        }
    }
    
    func groundContains(x: CGFloat) -> Bool {
        let testPoint = CGPoint(x: x, y: ground.frame.midY)
        return ground.frame.contains(testPoint)
    }
    
    func makeFireShadow(at x: CGFloat) -> SKSpriteNode {
        let size = CGSize(width: 10, height: 10)
        let position = CGPoint(x: x, y: frame.size.height/2)
        let fireDrop = SpriteFactory.makeFireDropShadow(withSize: size, at: position)
        return fireDrop
    }
}


// MARK: - Interactions

extension GameScene {
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let velocityX = player.physicsBody?.velocity.dx ?? 0
        let direction = velocityX > 0 ? PlayerDirection.left : .right
        move(inDirection: direction)
    }
    
    private func move(inDirection direction: PlayerDirection) {
        let velocity = CGVector(dx: 100 * direction.rawValue, dy: 0)
        player.physicsBody?.velocity = velocity
        player.texture = SKTexture(imageNamed: direction.imageName)
    }
}


// MARK: - Setup

private extension GameScene {
 
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.9)
        physicsWorld.contactDelegate = self
    }
    
    func addBackground() {
        let bg = SKSpriteNode(texture: SKTexture(imageNamed: "bg"), color: .blue, size: frame.size)
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.zPosition = -3
        addChild(bg)
    }
    
    func addGround() {
        let size = CGSize(width: frame.size.width/1.5, height: frame.size.height/2)
        let position = CGPoint(x: frame.size.width/2, y: size.height/2)
        ground = SpriteFactory.makeGround(withSize: size, at: position)
        addChild(ground)
    }
    
    func addPlayer() {
        let size = CGSize(width: 50, height: 50)
        let position = CGPoint(x: ground.frame.midX,
                                  y: ground.frame.maxY + size.height)
        player = SpriteFactory.makePlayer(withSize: size, at: position)
        addChild(player)
    }
}
