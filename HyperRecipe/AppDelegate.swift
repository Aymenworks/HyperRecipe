//
//  AppDelegate.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 19/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 243/255, green: 125/255, blue: 57/255, alpha: 1)], for: .selected)

    return true
  }

}

