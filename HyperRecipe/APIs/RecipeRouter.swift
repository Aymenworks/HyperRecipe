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
  static let token   = "IamWaitingForItButItsOkToUseStubAsWELLSoThereAreNoBugs#LazyMan#LoveJapan#"
  case get
  case delete(Int)
  case put(Int, [String: Any])
  case post([String: Any])
  
  var url: URL { return RecipeRouter.baseURL.appendingPathComponent(route.path) }
  
  var route: (path: String, parameters: [String: Any]?, method: HTTPMethod) {
    switch self {
    case .get: return ("/", nil, .get)
    case .delete(let id): return ("/\(id)", nil, .delete)
    case .put(let id, let parameters): return ("/\(id)", parameters, .put)
    case .post(let parameters): return ("/", parameters, .post)
    }
  }
}

extension RecipeRouter: URLRequestConvertible {
  func asURLRequest() throws -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = route.method.rawValue
    request.setValue(RecipeRouter.token, forHTTPHeaderField: "Authorization: Token")
    let urlRequest = try! URLEncoding().encode(URLRequest(url: url), with: route.parameters)
    return urlRequest
  }
  
}
