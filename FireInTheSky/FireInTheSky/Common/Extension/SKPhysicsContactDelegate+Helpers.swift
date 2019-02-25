//
//  SKPhysicsContactDelegate+Helpers.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 5/31/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

extension SKPhysicsContactDelegate {
    
    /**
        Check if two if physics categories both exist with a physics contact object.
     
        - Parameters:
            - contact: The physics contact object containing the pair physics bodies.
            - first: The first physics category.
            - second: The seconds physics category.
     */
    func hasContact<T>(_ contact: SKPhysicsContact, between first: T, and second: T)
        -> Bool where T: RawRepresentable, T.RawValue == UInt32 {
            let firstIsFirst = contact.bodyA.categoryBitMask == first.rawValue
                && contact.bodyB.categoryBitMask == second.rawValue
            let firstIsSecond = contact.bodyA.categoryBitMask == second.rawValue
                && contact.bodyB.categoryBitMask == first.rawValue
            return firstIsFirst || firstIsSecond
    }
}
