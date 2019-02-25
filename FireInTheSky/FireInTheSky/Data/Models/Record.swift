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
struct Record {
    
    /**
        The raw values for the keys used by the record model to store data.
     */
    struct Keys {
        
        /// Key for the name field.
        static let name = "name"
        
        /// Key for the score field.
        static let score = "score"
    }
    
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


// MARK: - Dictionary Convertible

extension Record: DictionaryConvertible {
    
    init?(dictionary: [String: Any]) {
        guard let score = dictionary[Keys.score] as? Double else {
            return nil
        }
        self.score = score
        name = dictionary[Keys.name] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if let name = name {
            dictionary[Keys.name] = name
        }
        dictionary[Keys.score] = score
        return dictionary
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
