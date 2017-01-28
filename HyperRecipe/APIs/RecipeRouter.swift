//
//  RecipeRouter.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 28/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire

// Inspired from https://littlebitesofcocoa.com/93-creating-a-router-for-alamofire. I recommand u this website :).
enum RecipeRouter {
  
  static let baseURL = URL(string: "http://hyper-recipes.herokuapp.com/recipes")!
  
  case get
  case delete(Int)
  case put(Int, Recipe)
  case post(Recipe)
  
  var url: URL { return RecipeRouter.baseURL.appendingPathComponent(route.path) }
  
  var route: (path: String, parameters: [String: Any]?) {
    switch self {
    case .get: return ("/", nil)
    case .delete(let id): return ("/\(id)", nil)
    case .put(let id, let recipe): return ("/\(id)", ["name": recipe.name])
    case .post: return ("/", nil)
    }
  }
}

extension RecipeRouter: URLRequestConvertible {
  func asURLRequest() throws -> URLRequest {
      return try! URLEncoding().encode(URLRequest(url: url), with: route.parameters)
  }
  
}
