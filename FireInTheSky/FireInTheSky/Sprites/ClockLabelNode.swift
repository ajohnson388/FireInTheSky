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
    
            guard highScore > 0, elapsedTime > highScore, !isClockHighlighted else {
                return
            }
            highlightClock()
        }
    }
    
    private var isClockHighlighted = false
    private var highScore: TimeInterval = 0
    
    override init() {
        super.init()
        fontSize = 40
        fontName = "Comic Sans"
        resetClock()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetClock() {
        removeAllChildren()
        text = "0:00"
        fontColor = .white
        isClockHighlighted = false
        highScore = RecordManager.shared.highScore?.score ?? 0
    }
    
    private func highlightClock() {
        // Change the clock color
        isClockHighlighted = true
        fontColor = .yellow
        
        // Add particle animation
        let fileName = "HighScoreSplash.sks"
        if let particleEmiiter = SKEmitterNode(fileNamed: fileName) {
            particleEmiiter.particlePositionRange = CGVector(dx: frame.size.width, dy: frame.size.height)
            particleEmiiter.targetNode = self
            particleEmiiter.particleLifetime = 20
            addChild(particleEmiiter)
        } else {
            print("Failed to load file \(fileName)")
        }
    }
}
