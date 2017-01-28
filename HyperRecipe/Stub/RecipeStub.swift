//
//  RecipeStub.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 22/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

struct RecipeStub: RecipeAPI {
  
  func getAllRecipes() -> Observable<[Recipe]> {
    return Observable<[Recipe]>.create { observer in
      do {
        let pathString = Bundle.main.path(forResource: "getRecipes", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: pathString))
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let recipes = try [Recipe].decode(json)
        let recipesResult: Result<[Recipe]> = .success(recipes)
        observer.onNext(recipesResult.value!)
      
      } catch {
          print(error)
          observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
  
  func deleteRecipe(id: Int) -> Observable<()> {
    return Observable.create { observer in
      let recipesResult: Result<()> = .success()
      observer.onNext(recipesResult.value!)
      
      return Disposables.create()
    }

  }
  
  func updateRecipe(id: Int, updatedRecipe: Recipe) -> Observable<Recipe> {
    return Observable<Recipe>.create { observer in
      do {
        let pathString = Bundle.main.path(forResource: "updateRecipe", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: pathString))
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let recipes = try Recipe.decode(json)
        let recipesResult: Result<Recipe> = .success(recipes)
        observer.onNext(recipesResult.value!)
        
      } catch {
        print(error)
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
  
  func createRecipe(recipe: Recipe) -> Observable<Recipe> {
    return Observable<Recipe>.create { observer in
      do {
        let pathString = Bundle.main.path(forResource: "createRecipe", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: pathString))
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let recipes = try Recipe.decode(json)
        let recipesResult: Result<Recipe> = .success(recipes)
        observer.onNext(recipesResult.value!)
        
      } catch {
        print(error)
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
}
