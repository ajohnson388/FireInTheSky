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
    
    private var ground: SKSpriteNode!
    private var player: SKSpriteNode!
    private let moveGesture = UITapGestureRecognizer(target: nil, action: nil)
    
    private var lastUpdateTime = 0.0
    private var elapsedTime = 0.0
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        // Configure the scene
        setupPhysicsWorld()
        setupMoveGesture()
        addBackground()
        addGround()
        addLava()
        addPlayer()
        
        // Start the player moving in a direction
        move(inDirection: .left)
        
        // Start droping fireballs
        makeItRainHell()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            self.elapsedTime += currentTime - lastUpdateTime
        }
        lastUpdateTime = currentTime
    }
}


// MARK: - Contact Delegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if hasContact(contact, between: PhysicsBitMask.player, and: .fire)
            || hasContact(contact, between: PhysicsBitMask.player, and: .lava) {
            showMenu()
        } else if hasContact(contact, between: PhysicsBitMask.fire, and: .ground)
            || hasContact(contact, between: PhysicsBitMask.fire, and: .lava),
            let fireDrop = getFireDrop(contact: contact) {
                removeFireDrop(fireDrop)
        }
    }
    
    func getFireDrop(contact: SKPhysicsContact) -> FireDrop? {
        return contact.bodyA.node as? FireDrop ?? contact.bodyB.node as? FireDrop
    }
}


// MARK: - Fire Drops

private extension GameScene {
    
    func makeItRainHell() {
        // TODO: Add progressive logic
        let wait = SKAction.wait(forDuration: LogicConfiguration.shared.fireDropPeriod)
        let spitFire = SKAction.run(addFireDrop)
        let sequence = SKAction.sequence([wait, spitFire])
        run(SKAction.repeatForever(sequence))
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
    }
    
    func removeFireDrop(_ fireDrop: FireDrop) {
        fireDrop.children.forEach { $0.removeFromParent() }
        fireDrop.removeFromParent()
        fireDrop.shadow?.removeFromParent()
    }
    
    func groundContains(x: CGFloat) -> Bool {
        let testPoint = CGPoint(x: x, y: ground.frame.midY)
        return ground.frame.contains(testPoint)
    }
    
    func makeFireShadow(at x: CGFloat) -> SKShapeNode {
        let size = CGSize(width: 24, height: 2)
        let position = CGPoint(x: x, y: frame.size.height/2 - size.height/2)
        let fireDrop = SpriteFactory.makeFireDropShadow(withSize: size, at: position)
        return fireDrop
    }
}


// MARK: - Interactions

private extension GameScene {
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let velocityX = player.physicsBody?.velocity.dx ?? 0
        let direction = velocityX > 0 ? PlayerDirection.left : .right
        move(inDirection: direction)
    }
    
    func move(inDirection direction: PlayerDirection) {
        let velocity = CGVector(dx: LogicConfiguration.shared.playerSpeed
            * CGFloat(direction.rawValue), dy: 0)
        player.physicsBody?.velocity = velocity
        player.texture = SKTexture(imageNamed: direction.imageName)
    }
}


// MARK: - Setup

private extension GameScene {
    
    func setupMoveGesture() {
        moveGesture.addTarget(self, action: #selector(didTap(_:)))
        view?.addGestureRecognizer(moveGesture)
    }
 
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
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
    
    func addLava() {
        let lavaSize = CGSize(width: frame.size.width * 2, height: 1)
        let lavaPosition = CGPoint(x: 0, y: -1)
        let lava = SpriteFactory.makeLava(withSize: lavaSize, at: lavaPosition)
        addChild(lava)
    }
    
    func addPlayer() {
        let size = CGSize(width: 50, height: 50)
        let position = CGPoint(x: ground.frame.midX,
                               y: ground.frame.maxY + size.height)
        player = SpriteFactory.makePlayer(withSize: size, at: position)
        addChild(player)
    }
}


// MARK: - Menu

extension GameScene {
    
    func stopScene() {
        moveGesture.isEnabled = false
        isPaused = true
    }
    
    func restartScene() {
        moveGesture.isEnabled = true
        isPaused = false
    }
    
    func showMenu() {
        guard let delegate = gameSceneDelegate else {
            // TODO: Handle error
            return
        }
        stopScene()
        
        // Set the record
        if RecordManager.shared.shouldSetRecord(score: elapsedTime) {
            // TODO: Prompt name entry
            let record = Record(name: nil, score: elapsedTime)
            RecordManager.shared.setRecord(record: record)
        }
        
        delegate.openGameMenu { [weak self] in
            self?.restartScene()
        }
    }
}




