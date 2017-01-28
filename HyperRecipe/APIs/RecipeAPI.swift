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
  func updateRecipe(id: Int, updatedRecipe: Recipe) -> Observable<Recipe>
  func createRecipe(recipe: Recipe) -> Observable<Recipe>
}
