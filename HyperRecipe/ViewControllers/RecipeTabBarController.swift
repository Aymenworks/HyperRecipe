//
//  RecipeTabBarController.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

class RecipeTabBarController: UITabBarController {
  
  // MARK: - Properties
  
  var addRecipeButton: UIButton!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addRecipeButton = UIButton(type: .custom)
    addRecipeButton.setImage(#imageLiteral(resourceName: "addRecipe"), for: .normal)
    addRecipeButton.addTarget(self, action: #selector(showRecipeFormController), for: .touchUpInside)
    
    view.addSubview(addRecipeButton)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    addRecipeButton.frame = CGRect(x: tabBar.frame.width/2 - 20, y: tabBar.frame.minY - 20, width: 40, height: 40)
  }
  
  // MARK: - User interaction
  
  func showRecipeFormController() {
    print("show recipe form controller")
    if let recipeController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeFormViewController") as? RecipeFormViewController {
      self.present(recipeController, animated: true)
    }
  }
}

// MARK: - Recipe form delegate
