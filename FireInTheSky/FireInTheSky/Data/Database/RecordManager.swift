//
//  RecordManager.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 6/2/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

/**
    A wrapper around the property list for storing and retrieving game records.
*/
final class RecordManager {
    
    // MARK: - Properties
    
    static var shared = RecordManager()
    
    private let recordsKey = "record"
    
    
    // MARK: - Lifecycle
    
    private init() {}
    
    
    // MARK: - Getters and Setters
    
    /**
        Returns the saved list of records in descending order of highest score.
     */
    var highScore: Record? {
        get {
            let data = UserDefaults.standard.data(forKey: recordsKey)
            return Record.decode(data: data)
        }
        set {
            UserDefaults.standard.set(newValue?.encode(), forKey: recordsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func shouldSetRecord(score: Double) -> Bool {
        guard let highScore = highScore else {
            return true
        }
        return score > highScore.score
    }
}
