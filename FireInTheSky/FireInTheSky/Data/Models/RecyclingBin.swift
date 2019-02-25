//
//  ObjectPool.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 9/2/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

class RecyclingBin<T> {
    
    var maxBinSize = 20
    
    private final var bin = [T]()
    
    final var recycledObject: T? {
        return bin.count > 0 ? bin.removeFirst() : nil
    }
    
    final func recycleObject(_ object: T) {
        guard bin.count < maxBinSize else { return }
        bin.append(object)
    }
    
    final func recycleObject(_ cleanup: () -> T) {
        let object = cleanup()
        bin.append(object)
    }
    
    final func reuseObject(_ configure: (T?) -> T) -> T {
        return configure(recycledObject)
    }
    
    final func dispose(_ cleanup: Optional<([T]) -> Void> = nil) {
        cleanup?(bin)
        bin.removeAll()
    }
}
