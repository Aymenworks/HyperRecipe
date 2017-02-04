//
//  SwinjectStoryboardExtension.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 22/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
  class func setup() {
    
    Container.loggingFunction = nil
    
    // Scheme HyperRecipe Stub/Run/Arguments and you'll find below the Stub argument
    if ProcessInfo.processInfo.arguments.contains("Stub") {
      defaultContainer.register(RecipeAPI.self) { _ in RecipeStub() }
    } else {
      defaultContainer.register(RecipeAPI.self) { _ in RecipeNetwork() }
    }
    
    defaultContainer.register(RecipeViewModel.self) { r in
      let viewModel = RecipeViewModel(service: r.resolve(RecipeAPI.self)!)
      return viewModel
    }
    
    defaultContainer.register(RecipeFormViewModel.self) { r in
      let viewModel = RecipeFormViewModel(service: r.resolve(RecipeAPI.self)!)
      return viewModel
    }

    defaultContainer.storyboardInitCompleted(ExploreViewController.self) { r, c in
      c.viewModel = r.resolve(RecipeViewModel.self)
    }
    
    defaultContainer.storyboardInitCompleted(RecipeFormViewController.self) { r, c in
      c.viewModel = r.resolve(RecipeFormViewModel.self)
    }
  }
}
