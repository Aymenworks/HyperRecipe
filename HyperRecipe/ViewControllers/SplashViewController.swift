//
//  SplashViewController.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 02/02/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      CAEmitterRecipe.animate(inView: self.view, duration: 0.3)
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.performSegue(withIdentifier: "showApp", sender: self)
      }
    }
}
