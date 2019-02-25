//
//  Timer.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 9/2/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

final class ClockLabelNode: SKLabelNode {
    
    var elapsedTime: TimeInterval = 0 {
        didSet {
            let minutes = Int(trunc(elapsedTime / 60))
            let seconds = Int(trunc(elapsedTime - Double(minutes * 60)))
            text = String(format: "%2d:%02d", minutes, seconds)
        }
    }
    
    override init() {
        super.init()
        text = "0:00"
        fontColor = .white
        fontSize = 40
        fontName = "Comic Sans"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
