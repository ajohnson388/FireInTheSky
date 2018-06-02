//
//  PlayerDirection.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/25/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

enum PlayerDirection: Int {
    case left = -1
    case right = 1
    
    var imageName: String {
        switch self {
        case .left: return "player_left"
        case .right: return "player_right"
        }
    }
}
