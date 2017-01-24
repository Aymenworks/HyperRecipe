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
    UITabBar.appearance().tintColor = UIColor.hyperOrange

    return true
  }

}

