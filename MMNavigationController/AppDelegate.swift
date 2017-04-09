//
//  AppDelegate.swift
//  MMNavigationController
//
//  Created by Mango on 2016/11/10.
//  Copyright © 2016年 MangoMade. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIViewController.mm.load()
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = MMNavigationController(rootViewController: NormalViewController())
        rootViewController.hideBottomLine()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }

}

