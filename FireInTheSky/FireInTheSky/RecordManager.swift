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
    func getRecords() -> [Record] {
        guard let records = UserDefaults.standard.array(forKey: recordsKey) as? [[String: Any]] else {
            return []
        }
        return records.compactMap {
            guard let score = $0[Record.Keys.score] as? Double else {
                return nil
            }
            return Record(name: $0[Record.Keys.name] as? String, score: score)
        }.sorted(by: >)
    }
    
    /**
        Saves a record to the list of high scores.
     */
    func setRecord(record: Record) {
        var originalRecords = UserDefaults.standard.array(forKey: recordsKey) as? [[String: Any]] ?? []
        originalRecords.append(record.toDictionary())
        UserDefaults.standard.setValue(originalRecords, forKey: recordsKey)
        UserDefaults.standard.synchronize()
    }
    
    func shouldSetRecord(score: Double) -> Bool {
        let records = getRecords()
        return records.first(where: { score > $0.score }) != nil && records.count < 3
    }
}
