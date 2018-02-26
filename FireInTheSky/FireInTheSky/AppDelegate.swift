//
//  AppDelegate.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/25/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let name = "GameViewController"
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: name, bundle:nil).instantiateViewController(withIdentifier: name)
        window?.makeKeyAndVisible()
        return true
    }
}

