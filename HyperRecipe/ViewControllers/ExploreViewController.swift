//
//  ExploreViewController.swift.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 19/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

class ExploreViewController: BaseViewController {
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    CAEmitterRecipe.animate(inView: self.view, duration: 0.3)
  }
}


