//
//  FireDrop.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/25/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

struct FireDrop {
    
    let droplet: SKSpriteNode
    let shadow: SKSpriteNode?
}


// MARK: - Equatable

extension FireDrop: Equatable {
    
    static func ==(lhs: FireDrop, rhs: FireDrop) -> Bool {
        return lhs.droplet == rhs.droplet
            && lhs.shadow == rhs.shadow
    }
}
