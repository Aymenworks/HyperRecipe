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

class RecipeFormViewController: UIViewController {
  
  // MARK: - Properties
  
  let disposeBag = DisposeBag()
  var viewModel: RecipeFormViewModel!
  var minY: CGFloat!
  var keyboardHeight: CGFloat!
  var finishGesture = false
  var isKeyboardVisible = false
  
  /*
   Used to replace the delegate and protocol boilerplate.
   */
  var formDidCancel = PublishSubject<Void>()
  var didCreateRecipe = PublishSubject<Recipe>()
  var didUpdateRecipe = PublishSubject<Recipe>()

  @IBOutlet weak var recipeNameTextField: UITextField!
  @IBOutlet weak var difficultyView: DifficultyView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var createButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var instructionsTextView: UITextView!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var pickImageButton: UIButton! {
    didSet {
      pickImageButton.layer.cornerRadius = 4.0
      pickImageButton.layer.masksToBounds = true
      pickImageButton.imageView?.contentMode = .scaleAspectFill
    }
  }
  
  @IBOutlet weak var formBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var formView: UIView! {
    didSet {
      formView.layer.cornerRadius = 8
      formView.layer.shadowColor = UIColor.white.cgColor
      formView.layer.shadowOffset = .zero
      formView.layer.shadowRadius = 3.0
      formView.layer.shadowOpacity = 1.0
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModel()
    
    if let recipe = viewModel.recipe {
      self.createButton.setTitle("Update", for: .normal)
      self.recipeNameTextField.text = recipe.0.name
      self.descriptionTextView.text = recipe.0.description
      self.instructionsTextView.text = recipe.0.instructions
      self.viewModel.currentLevel.value = recipe.0.difficulty
      self.favoriteButton.isSelected = recipe.0.favorite
      
      if let image = recipe.1 {
        self.pickImageButton.setImage(image, for: .normal)
      }
    }
    recipeNameTextField.becomeFirstResponder()
    
    let touchGesture = UIPanGestureRecognizer(target: self, action: #selector(RecipeFormViewController.moveForm(_:)))
    touchGesture.maximumNumberOfTouches = 1
    formView.addGestureRecognizer(touchGesture)
  }
  
  func moveForm(_ sender: UIPanGestureRecognizer) {
    
    if sender.state == .ended && !finishGesture {
      self.view.layoutIfNeeded()
      UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
        if self.isKeyboardVisible {
          self.formBottomConstraint.constant = self.keyboardHeight + 15.0
        } else {
          self.formBottomConstraint.constant = self.view.bounds.height / 2.0 - self.formView.bounds.height / 2.0
        }
        self.view.layoutIfNeeded()
      }, completion: nil)
      
    } else if self.formView.frame.minY > self.view.bounds.height / 2.0 {
      self.finishGesture = true
      self.view.endEditing(true)
      self.view.layoutIfNeeded()
      UIView.animate(withDuration: 0.5, animations: {
        
        self.formBottomConstraint.constant = -400
        self.view.layoutIfNeeded()
      }) { finish in
        if finish {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.formDidCancel.onNext()
          }
        }
      }
      
    } else  {
      let location = sender.location(in: view)
      if location.y > self.minY {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
          self.formBottomConstraint.constant = self.view.bounds.height - self.formView.bounds.height - location.y
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  
  func bindViewModel() {
    viewModel.currentLevel
      .asDriver()
      .distinctUntilChanged()
      .map { "\($0)"}
      .drive(onNext: { val in
        self.difficultyView.increaseLevelButton.setTitle(val, for: .normal)
      }).addDisposableTo(disposeBag)
    
    pickImageButton.rx.tap.asDriver().drive(onNext: {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      self.view.endEditing(true)
      self.present(imagePickerController, animated: true) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
          self.formBottomConstraint.constant = self.view.bounds.height / 2.0 - self.formView.bounds.height / 2.0
          self.view.layoutIfNeeded()
        }
      }
    }).addDisposableTo(disposeBag)
    
    favoriteButton.rx.tap.asDriver().drive(onNext: {
      self.favoriteButton.isSelected = !self.favoriteButton.isSelected
    }).addDisposableTo(disposeBag)
    
    cancelButton.rx.tap.asDriver().drive(onNext: {
      self.formDidCancel.onNext()
    }).addDisposableTo(disposeBag)
    
    createButton.rx.tap.asDriver().drive(onNext: {
      /* I used a dict because too many params and if the recipe has 10 more properties, it would be non readabl
       Also, I can't use the Recipe struct because it doesn't have the photo UIImage type and optionals values.
       Does it make sense to change the Recipe struct properties type for this case ? I don't think so, so I just inspired
       myself from Apple way of doing things ( you find dict on notification for example
       */
      var data: [String: Any] = [
        "recipeName": self.recipeNameTextField.text!,
        "recipeDifficulty": self.viewModel.currentLevel.value,
        "recipeFavorite": self.favoriteButton.isSelected]
      
      self.viewModel.recipe?.0.name = self.recipeNameTextField.text!
      self.viewModel.recipe?.0.difficulty = self.viewModel.currentLevel.value
      self.viewModel.recipe?.0.favorite = self.favoriteButton.isSelected

      if let recipePhoto = self.pickImageButton.imageView?.image {
        data["recipePhoto"] = recipePhoto
      }
      
      if let recipeDescription = self.descriptionTextView.text?.trimmingCharacters(in: .whitespaces), !recipeDescription.isEmpty {
        data["recipeDescription"] = recipeDescription
        self.viewModel.recipe?.0.description = recipeDescription
      }
      
      if let recipeInstructions = self.instructionsTextView.text?.trimmingCharacters(in: .whitespaces), !recipeInstructions.isEmpty {
        data["recipeInstructions"] = recipeInstructions
        self.viewModel.recipe?.0.instructions = recipeInstructions
      }
      
      // It's a creation
      if self.viewModel.recipe == nil {
        self.viewModel.createRecipe(withData: data)
          .asObservable()
          .subscribe(onNext: { createdRecipe in
            print("recipe created = \(createdRecipe)")
            self.didCreateRecipe.onNext(createdRecipe)
          }, onError: { error in
            print("error \(error)")
          }).addDisposableTo(self.disposeBag)
        
        // It's an update
      } else {
        self.viewModel.updateRecipe(withData: data)
          .asObservable()
          .subscribe(onNext: {
            self.didUpdateRecipe.onNext(self.viewModel.recipe!.0)
          }, onError: { error in
            print("error \(error)")
          }).addDisposableTo(self.disposeBag)
      }
    }).addDisposableTo(disposeBag)
    
    difficultyView.levelDidIncrease.asObservable().subscribe(onNext: {
      self.viewModel.currentLevel.value = min(self.viewModel.currentLevel.value + 1, self.viewModel.maximumLevel)
    }).addDisposableTo(disposeBag)
    
    difficultyView.levelDidDecrease.asObservable().subscribe(onNext: {
      self.viewModel.currentLevel.value = max(self.viewModel.currentLevel.value - 1, self.viewModel.minimumLevel)
    }).addDisposableTo(disposeBag)
    
    // Only the recipe name and the level are obligatory ( the level is by default )
    let validRecipeName = recipeNameTextField.rx.text.orEmpty.map(viewModel.notEmpty).asDriver(onErrorJustReturn: false)
    validRecipeName.drive(createButton.rx.isEnabled).addDisposableTo(disposeBag)
    
    NotificationCenter.default
      .rx.notification(.UIKeyboardWillShow)
      .asObservable()
      .subscribe(onNext: { notification in
        self.isKeyboardVisible = true
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
          self.keyboardHeight = keyboardFrame.height
          self.formBottomConstraint.constant = keyboardFrame.height + 15.0
          self.minY = self.view.bounds.height - keyboardFrame.height - 15.0 - self.formView.bounds.height
          self.view.layoutIfNeeded()
        }
      }).addDisposableTo(disposeBag)
    
    NotificationCenter.default
      .rx.notification(.UITextFieldTextDidEndEditing)
      .asObservable()
      .subscribe(onNext: { notification in
        self.isKeyboardVisible = false
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5) {
          self.formBottomConstraint.constant = self.view.bounds.height / 2.0 - self.formView.bounds.height / 2.0
          self.view.layoutIfNeeded()
        }
      }).addDisposableTo(disposeBag)
  }
}

// MARK: - Image Picker Delegate

extension RecipeFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      pickImageButton.setImage(pickedImage, for: .normal)
    }
  }
}
