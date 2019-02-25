//
//  Logger.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/25/19.
//  Copyright © 2019 Andrew Johnson. All rights reserved.
//

import Foundation

struct Logger {
    
    static func log(_ items: Any...) {
        #if DEBUG
            print(items)
        #endif
    }
}
