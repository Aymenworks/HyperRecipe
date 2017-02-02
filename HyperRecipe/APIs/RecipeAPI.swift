//
//  RecipeAPI.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RecipeAPI {
  func getAllRecipes() -> Observable<[Recipe]>
  func deleteRecipe(id: Int) -> Observable<()>
  func updateRecipe(withId id: Int, andData data: [String: Any]) -> Observable<Recipe>
  func createRecipe(withData data: [String: Any]) -> Observable<Recipe>
}
