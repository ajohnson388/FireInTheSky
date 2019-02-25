//
//  StatusBar.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 9/9/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

final class StatusBar: SKSpriteNode {
    
    var highScore = ClockLabelNode()
    var clock = ClockLabelNode()
    var hitPoints = [HitPoint]()
    
//    override init(size: CGSize) {
//        super.init(texture: nil, color: .black, size: size)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBorder() {
        
    }
    
    func addHitPoints() {
        
    }
    
    func addClock() {
        
    }
    
    func addHighScore() {
        
    }
}
