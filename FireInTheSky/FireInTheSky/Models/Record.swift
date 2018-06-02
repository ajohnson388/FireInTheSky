//
//  Record.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 5/31/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

struct Record {
    
    var name: String?
    var score = 0.0
    
    struct Keys {
        static let name = "name"
        static let score = "score"
    }
    
    init(name: String?, score: Double) {
        self.name = name
        self.score = score
    }
    
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
    
    
    

