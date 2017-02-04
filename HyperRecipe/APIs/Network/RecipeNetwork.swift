//
//  RecipeNetwork.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import Decodable
import Alamofire
import RxSwift
import RxCocoa

struct RecipeNetwork: RecipeAPI {
  func getAllRecipes() -> Observable<[Recipe]> {
    return Observable<[Recipe]>.create { observer in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      
      request(RecipeRouter.get)
        .responseJSON { jsonResponse in

          UIApplication.shared.isNetworkActivityIndicatorVisible = false

          switch jsonResponse.result {
          case .success(let value):
            do {
              let recipes = try [Recipe].decode(value)
              print("recipes = \(recipes)")
              observer.onNext(recipes)
              
            } catch let error {
              print(error)
             observer.onError(error)
            }
          case .failure(let error):
            observer.onError(error)
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  func deleteRecipe(id: Int) -> Observable<()> {
    return Observable<()>.create { observer in
    
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      
      request(RecipeRouter.delete(id))
        .response { response in
          
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          
          if let error = response.error {
            print(error)
            observer.onError(error)
          } else {
            print("recipe deleted")
            observer.onNext()
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  func updateRecipe(withId id: Int, andData data: [String: Any]) -> Observable<()> {
    return Observable<()>.create { observer in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      
      request(RecipeRouter.put(id, data))
        .responseJSON { jsonResponse in
          
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          
          switch jsonResponse.result {
          case .success(_):
              observer.onNext()
          case .failure(let error):
            print(error)
            observer.onError(error)
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  func createRecipe(withData data: [String: Any]) -> Observable<Recipe> {
    return Observable<Recipe>.create { observer in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      request(RecipeRouter.post(data))
        .responseJSON { jsonResponse in
          
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          
          switch jsonResponse.result {
          case .success(let value):
            do {
              let recipe = try Recipe.decode(value)
              print("recipe created")
              observer.onNext(recipe)
              
            } catch let error {
              print(error)
              observer.onError(error)
            }
          case .failure(let error):
            print(error)
            observer.onError(error)
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}

