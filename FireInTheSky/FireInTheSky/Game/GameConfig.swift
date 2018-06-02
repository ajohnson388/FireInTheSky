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
    
    var playerSpeed: CGFloat = 100
    var fireDropPeriod: TimeInterval = 0.66
}
