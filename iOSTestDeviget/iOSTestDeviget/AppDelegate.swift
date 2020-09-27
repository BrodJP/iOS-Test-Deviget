//
//  AppDelegate.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication,
                     shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        true
    }
    
    func application(_ application: UIApplication,
                     shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        true
    }
}

