//
//  GameSceneActionFactory.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 9/2/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

final class GameSceneActionFactory {
    
    /**
        Starts the timer by triggering model and UI updates every second.
        This should be called when the game is started.
     */
    func makeTimer(interval: TimeInterval, onTimeElapsed: @escaping () -> Void) -> SKAction {
        let increment = SKAction.run(onTimeElapsed)
        let wait = SKAction.wait(forDuration: interval)
        let timing = SKAction.group([increment, wait])
        return SKAction.repeatForever(timing)
    }
    
    /**
        Triggers the sequence of fire drops.
     */
    func makeItRainHell(onSpitFire: @escaping () -> Void) -> SKAction {
        let wait = SKAction.wait(forDuration: LogicConfiguration.shared.fireDropPeriod)
        let spitFire = SKAction.run(onSpitFire)
        let sequence = SKAction.sequence([wait, spitFire])
        return SKAction.repeatForever(sequence)
    }
}
