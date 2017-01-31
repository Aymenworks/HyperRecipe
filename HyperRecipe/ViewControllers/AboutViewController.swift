//
//  AboutViewController.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

  // MARK: - User Interaction

  @IBAction func redirectToBlog(_ sender: Any) {
    if let url = URL(string: "http://aymenworks.com") {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}
