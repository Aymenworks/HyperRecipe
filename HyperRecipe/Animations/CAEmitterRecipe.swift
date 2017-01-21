//
//  CAEmitterRecipe.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 21/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit

// Animation inspired a lot lot from https://github.com/sudeepag/SAConfettiView.
struct CAEmitterRecipe {
  
  // MARK: - Properties
  
  private static var shared = CAEmitterRecipe()
  
  let fruitAndVegetablesImages = [#imageLiteral(resourceName: "broccoli"), #imageLiteral(resourceName: "cherry"), #imageLiteral(resourceName: "chicken-leg"), #imageLiteral(resourceName: "fried-egg"), #imageLiteral(resourceName: "grapes"), #imageLiteral(resourceName: "lobster"),
                                  #imageLiteral(resourceName: "meat"), #imageLiteral(resourceName: "orange"), #imageLiteral(resourceName: "cheese"), #imageLiteral(resourceName: "pear"), #imageLiteral(resourceName: "pizza"), #imageLiteral(resourceName: "strawberry"), #imageLiteral(resourceName: "watermelon"),
                                  #imageLiteral(resourceName: "ham"), #imageLiteral(resourceName: "melon"), #imageLiteral(resourceName: "mushroom")]
  
  let emitter = CAEmitterLayer()
  var i = 0; // Used later for displaying different size of fruit/vegetables

  // MARK: - Lifecycle
  
  static func animate(inView view: UIView, duration: TimeInterval) {
    view.layer.addSublayer(shared.emitter)
    shared.emitter.emitterShape  = kCAEmitterLayerLine
    shared.emitter.emitterCells  = shared.fruitAndVegetablesImages.randomSort().map { shared.emitterCell(withImage: $0) }
    
    shared.emitter.emitterPosition = CGPoint(x: view.frame.width/2, y: shared.startingYPoint(view))
    shared.emitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      shared.stop()
    }
  }
  
  private func stop() {
    emitter.birthRate  = 0
  }
  
  private mutating func emitterCell(withImage image: UIImage) -> CAEmitterCell {
    let emitterCell = CAEmitterCell()
    emitterCell.birthRate = 1.2
    emitterCell.lifetime = 7 // Life time in seconds of each fruit/vegetable
    emitterCell.velocity = CGFloat(120) // the bigger the value is, the quicker the fruit move
    emitterCell.emissionLongitude = CGFloat(M_PI) // It seems like it's the orientation 🤔
    emitterCell.emissionRange = CGFloat(M_PI_4) // 🤡😐
    emitterCell.spin = CGFloat(0.8) // Rotation
    emitterCell.scaleSpeed = i % 4 == 0 ? -0.4 : -0.1 // The bigger the value is, the quicker the fruit size grow
    emitterCell.contents = image.cgImage
  
    i += 1
    
    return emitterCell
  }

  // MARK: - Utils
  
  /*
    Because I want my animation to start below the navigation bar 
    and because I don't want to hardcode value ( even If I do that time to time ), I look for
    the controller behind the view in which we play the animation, and search if there are any
    navigation bar to get its maxY properties. 
    
    I'm not bad at googling c.f http://stackoverflow.com/questions/1372977/given-a-view-how-do-i-get-its-viewcontroller
 */
  func startingYPoint(_ view: UIView) -> CGFloat {
    var responder = view.next
    while responder != nil {
      if let navigationController = (responder as? UIViewController)?.navigationController {
        return navigationController.navigationBar.frame.maxY
      }
      responder = responder?.next
    }
    
    return 0
  }
}
