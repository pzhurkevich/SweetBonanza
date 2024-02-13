//
//  AppDelegate.swift
//  SweetBonanza
//
//  Created by Pavel on 8.02.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = LoadingViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

