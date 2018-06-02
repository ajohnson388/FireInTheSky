//
//  Button.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 3/12/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import SpriteKit

final class Button: SKSpriteNode {
    
    // MARK: - Properties
    
    var backgroundColor: UIColor = .blue
    var onButtonTapped: Optional<() -> Void>
    
    
    // MARK: - Object Lifecycle
    
    init() {
        super.init(texture: nil, color: .blue, size: CGSize.zero)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
}


// MARK: - Setup

extension Button {
    
    func setupButton() {
        isUserInteractionEnabled = true
        size = CGSize(width: 100, height: 50)
        didEndInteraction()
    }
}


// MARK: - Touch Events

extension Button {
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        didStartInteraction()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        didEndInteraction()
        if let location = touches.first?.location(in: self), contains(location) {
            onButtonTapped?()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let location = touches.first?.location(in: self),
            contains(location) else {
            return
        }
        didEndInteraction()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        didEndInteraction()
    }
    
    func didStartInteraction() {
        // Show highlight color
        self.color = backgroundColor.withAlphaComponent(0.8)
    }
    
    func didEndInteraction() {
        // Show normal color
        self.color = backgroundColor
    }
}
