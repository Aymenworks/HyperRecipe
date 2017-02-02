//
//  RecipeViewModel.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 22/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct RecipeViewModel {
  
  // MARK: - Properties
  
  let service: RecipeAPI
  var recipes = [Recipe]()
  let error = Variable<Error?>(nil)

  var currentLevel = 2
  
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  init(service: RecipeAPI) {
    self.service = service
  }
  
  // MARK: - Network
  
  func getAllRecipes() -> Observable<[Recipe]> {
    return Observable<[Recipe]>.create { observer in
    self.service.getAllRecipes().subscribe(
      onNext: { recipes in
        observer.onNext(recipes)
      },
      onError: { error in
        observer.onError(error)
      }).addDisposableTo(self.disposeBag)
      return Disposables.create()
    }
  }
}
