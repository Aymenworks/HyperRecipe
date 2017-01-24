//
//  RecipeFormViewController.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RecipeFormViewController: BaseViewController {
  
  // MARK: - Properties
  
  /*
    Used to replace the delegate and protocol boilerplate. 
    Those are properties observed by the RecipeTabBarController
  */
  var formDidCancel = PublishSubject<Void>()
  var didCreateRecipe = PublishSubject<Recipe>()
  
  @IBOutlet weak var recipeNameTextField: UITextField!
  @IBOutlet weak var difficultyView: DifficultyView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var createButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var instructionsTextView: UITextView!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var pickImageButton: UIButton!
  @IBOutlet weak var formBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var formView: UIView! {
    didSet {
      formView.layer.cornerRadius = 8
    }
  }
  
  var viewModel = RecipeFormViewModel()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    recipeNameTextField.becomeFirstResponder()
  }
  
  override func bindViewModel() {
    viewModel.currentLevel
      .asDriver()
      .distinctUntilChanged()
      .map { "\($0)"}
      .drive(onNext: { val in
        self.difficultyView.increaseLevelButton.setTitle(val, for: .normal)
      }).addDisposableTo(disposeBag)
    
    /*
     recipeNameTextField.rx.text.orEmpty.asDriver()
     instructionsTextView.rx.text.orEmpty.asDriver()
     descriptionTextView.rx.text.orEmpty.asDriver()
     */
    pickImageButton.rx.tap.asDriver().drive(onNext: {
      // pick photo controller
    }).addDisposableTo(disposeBag)
    
    favoriteButton.rx.tap.asDriver().drive(onNext: {
      // selected or not
    }).addDisposableTo(disposeBag)
    
    cancelButton.rx.tap.asDriver().drive(onNext: {
      self.formDidCancel.onNext()
    }).addDisposableTo(disposeBag)
    
    difficultyView.levelDidIncrease.asObservable().subscribe(onNext: {
      self.viewModel.currentLevel.value = min(self.viewModel.currentLevel.value + 1, self.viewModel.maximumLevel)
    }).addDisposableTo(disposeBag)
    
    difficultyView.levelDidDecrease.asObservable().subscribe(onNext: {
      self.viewModel.currentLevel.value = max(self.viewModel.currentLevel.value - 1, self.viewModel.minimumLevel)
    }).addDisposableTo(disposeBag)
    

  }
}
