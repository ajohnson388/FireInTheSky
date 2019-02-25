//
//  GameSceneDelegate.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 5/31/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

protocol GameSceneDelegate: class {
    func openGameMenu(isGameOver: Bool, completionHandler: @escaping () -> Void)
}
