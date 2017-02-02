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
  
  func updateRecipe(withId id: Int, andData data: [String: Any]) -> Observable<Recipe> {
    return Observable<Recipe>.create { observer in
      do {
        let recipe = Recipe(id: id, name: data["recipeName"] as! String, description: (data["recipeDescription"] as? String) ?? "zeofezofk ezok ezok ez,so kdzotj", instructions: (data["recipeInstructions"] as? String) ?? "dokzodk zok zork zo,zo dzo jzfj ozkd ozkd ozkoez ozn sozks ozk", favorite: data["recipeFavorite"] as! Bool, difficulty: data["recipeDifficulty"] as! Int, createdDate: "2014-09-29T10:43:00.072Z", updatedDate: "2014-09-29T10:43:00.072Z", photo: Photo(url: "", thumbnailUrl: ""))
        observer.onNext(recipe)
        
      } catch {
        print(error)
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
  
  func createRecipe(withData data: [String: Any]) -> Observable<Recipe> {
    return Observable<Recipe>.create { observer in
        let recipe = Recipe(id: 4, name: data["recipeName"] as! String, description: (data["recipeDescription"] as? String) ?? "zeofezofk ezok ezok ez,so kdzotj", instructions: (data["recipeInstructions"] as? String) ?? "dokzodk zok zork zo,zo dzo jzfj ozkd ozkd ozkoez ozn sozks ozk", favorite: data["recipeFavorite"] as! Bool, difficulty: data["recipeDifficulty"] as! Int, createdDate: "2014-09-29T10:43:00.072Z", updatedDate: "2014-09-29T10:43:00.072Z", photo: Photo(url: "", thumbnailUrl: ""))
        observer.onNext(recipe)
      
      return Disposables.create()
    }
  }
}
