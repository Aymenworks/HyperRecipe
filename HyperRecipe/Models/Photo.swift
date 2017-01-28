//
//  Photo.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import Decodable


struct Photo {
  let url: String
  let thumbnailUrl: String
}

extension Photo: Decodable {
  public static func decode(_ json: Any) throws -> Photo {
    return try Photo(
      url: json => "url",
      thumbnailUrl: json => "thumbnail_url"
    )
  }
}
