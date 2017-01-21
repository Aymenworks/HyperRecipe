//
//  DifficultyView.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

@IBDesignable
class DifficultyView: UIView {
  
  // MARK: - Properties

  let minimumLevel = 1
  let maximumLevel = 3
  
  var currentLevel = 2 {
    didSet {
      increaseLevelButton.setTitle("\(currentLevel)", for: .normal)
    }
  }
  
  var contentView: UIView!
  
  @IBOutlet weak var increaseLevelButton: UIButton! {
    didSet {
      increaseLevelButton.setTitle("\(currentLevel)", for: .normal)
      increaseLevelButton.layer.cornerRadius = 21.5
    }
  }
  
  @IBOutlet weak var decreaseLevelButtton: UIButton! {
    didSet {
      decreaseLevelButtton.layer.borderColor = UIColor.hyperDarkBlue.cgColor
      decreaseLevelButtton.layer.borderWidth = 2.0
      decreaseLevelButtton.layer.cornerRadius = 10.5
    }
  }
  
  // MARK: - Lifecycle
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  func setup() {
    if let contentView = loadViewFromNib() {
      contentView.backgroundColor = .clear
      contentView.frame = bounds
      
      // Make the view stretch with containing view
      
      // Adding custom subview on top of our view (over any custom drawing > see note below)
      addSubview(contentView)
    }
  }
  
  func loadViewFromNib() -> UIView! {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    
    return view
  }
  
  // MARK: - User interaction

  @IBAction func decreaseLevel(_ sender: Any) {
    currentLevel = max(minimumLevel, currentLevel-1)
  }
  
  @IBAction func increaseLevel(_ sender: Any) {
    currentLevel = min(maximumLevel, currentLevel+1)
  }
}
