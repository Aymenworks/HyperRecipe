//
//  ArrayExtension.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation

extension Array {
  func randomSort() -> Array {
    let sortedArray = sorted { _ in arc4random() < arc4random()  }
    return sortedArray
  }
}
