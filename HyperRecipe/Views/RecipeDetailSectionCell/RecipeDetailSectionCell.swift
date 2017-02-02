//
//  RecipeDetailSectionCell.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 28/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

class RecipeDetailSectionCell: UITableViewCell {
  
  @IBOutlet weak var headerView: UIView! 
  
  @IBOutlet weak var mainView: UIView! {
    didSet {
      mainView.layer.cornerRadius = 5
      mainView.layer.shadowColor = UIColor(red: 221/255, green: 221/250, blue: 221/250, alpha: 1.0).cgColor
      mainView.layer.shadowOffset = .zero
      mainView.layer.shadowRadius = 5.0
      mainView.layer.shadowOpacity = 1.0
    }
  }
  
  override func layoutSubviews() {
    let bezierPath = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
    let maskLayer = CAShapeLayer()
    maskLayer.path = bezierPath.cgPath
    headerView.layer.mask = maskLayer
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
}
