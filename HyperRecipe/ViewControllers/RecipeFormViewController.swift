//
//  RecipeFormViewController.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

protocol RecipeFormDelegate: class {
}

class RecipeFormViewController: UIViewController {
  
  // MARK: - Properties
  
  weak var delegate: RecipeFormDelegate?
  @IBOutlet weak var recipeNameTextField: UITextField!
  @IBOutlet weak var difficultyView: DifficultyView!
  
  @IBOutlet weak var formView: UIView! {
    didSet {
      formView.layer.cornerRadius = 8      
    }
  }
  
  @IBOutlet weak var formBottomConstraint: NSLayoutConstraint!
  
  // MARK: - Lifecycle

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    recipeNameTextField.becomeFirstResponder()
  }

}
