//
//  JsonConvertible.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 6/24/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

/**
    A type that can be decoded from and encoded to JSON in the form of dictionary.
 */
protocol DictionaryConvertible {
    
    /**
        Decodes JSON into the concrete data type.
     
        - Parameters:
            - json: The JSON object to build the data model from.
     */
    init?(dictionary: [String: Any])
    
    /**
        Encodes a concrete data type into a JSON dictionary.
     
        - Returns: The data model encapsulated as JSON.
     */
    func toDictionary() -> [String: Any]
}
