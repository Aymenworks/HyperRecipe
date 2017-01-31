//
//  BaseNavigationViewController.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 31/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

  // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

      navigationBar.shadowImage = UIImage()
      navigationBar.setBackgroundImage(UIImage(), for: .default)
  }
}
