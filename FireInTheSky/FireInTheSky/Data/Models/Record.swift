//
//  Record.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 5/31/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

/**
    A model for the data captured during a game session.
 */
struct Record: Codable {
    
    /// The name of the player, restricted to three characters.
    var name: String?
    
    /// The eleapsed time accomplished by the player.
    var score = 0.0
    
    /**
        Primary initializer for creating a record when the game ends.
    
        - Parameters:
            - name: The name of player, restricted to 3 characters.
            - score: The elapsed time during a game session.
     */
    init(name: String?, score: Double) {
        self.name = name
        self.score = score
    }
}


// MARK: - Comparable

extension Record: Comparable {
    
    static func < (lhs: Record, rhs: Record) -> Bool {
        return lhs.score < rhs.score
    }

    static func > (lhs: Record, rhs: Record) -> Bool {
        return lhs.score > rhs.score
    }
    
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.score == rhs.score && lhs.name == rhs.name
    }
}
