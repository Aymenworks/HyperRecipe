//
//  RecipeFormViewModel.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct RecipeFormViewModel {
  
  // MARK: - Properties
  
  let service: RecipeAPI
  var currentLevel = Variable<Int>(2)
  let disposeBag = DisposeBag()
  var recipe:  (Recipe, UIImage?)? // A non nil value means that it's an update

  // MARK: - Lifecycle
  
  init(service: RecipeAPI) {
    self.service = service
  }
  
  // MARK: - Rules
  
  let minimumLevel = 1
  let maximumLevel = 3
  
  let notEmpty: ((String) -> Bool) =  { (text: String) in !text.isEmpty }
  
  // MARK: - Network
  
  func createRecipe(withData data: [String: Any]) -> Observable<Recipe> {
    return Observable<Recipe>.create { observer in
      self.service.createRecipe(withData: data).subscribe(onNext: { recipe in
        observer.onNext(recipe)
      }, onError: { error in
        observer.onError(error)
      }, onCompleted: {
        observer.onCompleted()
      }).addDisposableTo(self.disposeBag)
        return Disposables.create()
    }
  }
  
  func updateRecipe(withData data: [String: Any]) -> Observable<()> {
    return Observable<()>.create { observer in
      self.service.updateRecipe(withId: self.recipe!.0.id, andData: data).subscribe(onNext: {
        observer.onNext()
      }, onError: { error in
        observer.onError(error)
      }, onCompleted: {
        observer.onCompleted()
      }).addDisposableTo(self.disposeBag)
      return Disposables.create()
    }
  }
}
