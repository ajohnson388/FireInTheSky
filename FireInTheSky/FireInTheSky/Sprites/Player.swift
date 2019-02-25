//
//  Player.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 9/2/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

final class Player: SKSpriteNode {
    
    enum Direction: Int {
        
        /// The player direction when it moves left.
        case left = -1
        
        /// The player direction when it moves right.
        case right = 1
        
        /**
            Returns the name of image asset file that should be used for the given player direction.\
         */
        var imageName: String {
            switch self {
            case .left: return "player_left"
            case .right: return "player_right"
            }
        }
    }
    
    var isBurning = false
    private let playerSize: CGSize
    
    init(size: CGSize, position: CGPoint) {
        playerSize = size
        super.init(texture: nil, color: .green, size: size)
        self.position = position
        setupSprite()
        setupPhysicsBody()
        name = Node.player.rawValue
        texture = SKTexture(imageNamed: "player_left")
    }
    
    func move(_ direction: Player.Direction) -> Bool {
        guard let physicsBody = physicsBody, physicsBody.velocity.dy == 0 else {
            return false
        }
        
        let velocity = CGVector(
            dx: LogicConfiguration.shared.playerSpeed * CGFloat(direction.rawValue),
            dy: 0
        )
        physicsBody.velocity = velocity
        texture = SKTexture(imageNamed: direction.imageName)
        return true
    }
    
    /**
        Responsbile for animating the death of the player.
     */
    func killPlayer(completion: @escaping () -> ()) {
        // Set player on fire
        isBurning = true
        physicsBody?.velocity = CGVector.zero
        physicsBody?.isDynamic = false
        let fileName = "FireDrop.sks"
        if let particleEmiiter = SKEmitterNode(fileNamed: fileName) {
            particleEmiiter.particleBirthRate = 40
            particleEmiiter.particlePositionRange = CGVector(dx: size.width, dy: size.height)
            particleEmiiter.targetNode = self
            addChild(particleEmiiter)
        } else {
            print("Failed to load file \(fileName)")
        }
        
        let duration = 0.3
        let melt = SKAction.resize(toWidth: 0, height: 0, duration: duration)
        let move = SKAction.moveBy(x: size.width / 2, y: -size.height, duration: duration)
        let group = SKAction.group([melt, move])
        let melted = SKAction.run {
            self.isHidden = true
            self.isBurning = false
            self.size = self.playerSize
            self.physicsBody?.isDynamic = true
            completion()
        }
        run(SKAction.sequence([group, melted]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSprite() {
        name = Node.player.rawValue
        texture = SKTexture(imageNamed: "player_left")
    }
    
    private func setupPhysicsBody() {
        let bodySize = CGSize(width: size.width / 1.5, height: size.height * 0.9)
        let x = (bodySize.width - size.width ) / 2
        let y = (bodySize.height - size.height) / 2
        let center = CGPoint(x: x, y: y)
        
        physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: center)
        physicsBody?.affectedByGravity = true
        physicsBody?.contactTestBitMask = PhysicsBitMask.fire.rawValue | PhysicsBitMask.lava.rawValue
        physicsBody?.categoryBitMask = PhysicsBitMask.player.rawValue
        physicsBody?.collisionBitMask = PhysicsBitMask.ground.rawValue
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
    }
}
