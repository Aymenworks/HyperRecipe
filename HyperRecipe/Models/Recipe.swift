//
//  Recipe.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 19/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import Decodable

struct Recipe {
  let id: Int
  var name: String
  var description: String
  var instructions: String
  var favorite: Bool
  var difficulty: Int
  let createdDate: String
  let updatedDate: String
  let photo: Photo
}

extension Recipe: Decodable {
  public static func decode(_ json: Any) throws -> Recipe {
    return try Recipe(
      id: json => "id",
      name: json => "name",
      description: json => "description",
      instructions: json => "instructions",
      favorite: json => "favorite",
      difficulty: json => "difficulty",
      createdDate: json => "created_at",
      updatedDate: json => "updated_at",
      photo: json => "photo"
    )
  }
}
