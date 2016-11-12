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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIViewController.mm_load()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let rootViewController = MMNavigationController(rootViewController: NormalViewController())
        rootViewController.hideBottomLine()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }

}

