//
//  GameScenePhysicsHandler.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 9/2/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameScenePhysicsHandlerDelegate: class {
    func onPlayerHit()
    func onSpitFireExtinguished(_ spitFire: SpitFire)
}

final class GameScenePhysicsHandler: NSObject {
    
    unowned var delegate: GameScenePhysicsHandlerDelegate
    
    init(delegate: GameScenePhysicsHandlerDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    /**
        Checks if the game should end.
     */
    private func didDetectPlayerHit(contact: SKPhysicsContact) -> Bool {
        return hasContact(contact, between: PhysicsBitMask.player, and: .fire)
            || hasContact(contact, between: PhysicsBitMask.player, and: .lava)
    }
    
    /**
        Checks if the fire drop should be removed/recycled.
     */
    private func didDetectSpitFireExtinguished(contact: SKPhysicsContact) -> Bool {
        return hasContact(contact, between: PhysicsBitMask.fire, and: .ground)
            || hasContact(contact, between: PhysicsBitMask.fire, and: .lava)
    }
    
    /**
        Checks the bodies bound to a contact object and returns the first found
        SpitFire object.
     */
    private func getSpitFire(contact: SKPhysicsContact) -> SpitFire? {
        return contact.bodyA.node as? SpitFire
            ?? contact.bodyB.node as? SpitFire
    }
}


// MARK: - Contact Delegate

extension GameScenePhysicsHandler: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if didDetectPlayerHit(contact: contact) {
            delegate.onPlayerHit()
        } else if didDetectSpitFireExtinguished(contact: contact),
            let spitFire = getSpitFire(contact: contact) {
            delegate.onSpitFireExtinguished(spitFire)
        }
    }
}
