//
//  Button.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/19/19.
//  Copyright © 2019 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    
    var onButtonTapped: Optional<() -> ()>

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setTouched(containsTouch(touches))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if containsTouch(touches) {
            onButtonTapped?()
        }
        setTouched(false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setTouched(containsTouch(touches))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setTouched(false)
    }
    
    private func setTouched(_ isTouched: Bool) {
        alpha = isTouched ? 0.2 : 1
    }
    
    private func containsTouch(_ touches: Set<UITouch>) -> Bool {
        guard let touch = touches.first else {
            return false
        }
        
        let location = touch.location(in: self)
        let hasTouch = containsDimension(dimension: location.x, boundary: size.width)
            && containsDimension(dimension: location.y, boundary: size.height)
        return hasTouch
    }
    
    private func containsDimension(dimension: CGFloat, boundary: CGFloat) -> Bool {
        let halfBound = boundary / 2
        return -halfBound <= dimension && dimension <= halfBound
    }
}
