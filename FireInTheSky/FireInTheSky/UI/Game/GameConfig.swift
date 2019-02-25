//
//  GameConfig.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 3/4/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import CoreGraphics

final class LogicConfiguration {
    
    private(set) static var shared: LogicConfiguration = LogicConfiguration()
    
    var playerDeathSpeed: CGFloat = 50
    var playerSpeed: CGFloat = 135
    var fireDropPeriod: TimeInterval = 0.18
}
