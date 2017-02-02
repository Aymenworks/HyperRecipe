//
//  RecipeCollectionViewCell.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 22/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit
import expanding_collection
import RxSwift
import RxCocoa

class RecipeCollectionViewCell: BasePageCollectionCell {
  
  // MARK: - Properties

  let disposeBag = DisposeBag()
  @IBOutlet weak var recipeImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var flagFavorite: UIImageView!
  
  var isFavorite = false {
    didSet {
      flagFavorite.isHidden = isFavorite == false
    }
  }
  
  var recipe: Recipe! {
    didSet {
      titleLabel.text = recipe.name
      descriptionLabel.text = recipe.description
      isFavorite = recipe.favorite
    }
  }
}
