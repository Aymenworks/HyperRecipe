//
//  RecipeExpandingTableViewController.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 22/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit
import expanding_collection
import RxSwift
import RxCocoa

class RecipeExpandingTableViewController: ExpandingTableViewController {
  
  // MARK: - Properties
  
  let disposeBag = DisposeBag()
  var recipe:  (Recipe, UIImage?)! // A non nil value means that it's an update
  
  /*
   Used to replace the delegate and protocol boilerplate.
   */
  var recipeDidDelete = PublishSubject<Recipe>()
  var recipeDidUpdate = PublishSubject<Recipe>()

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.alwaysBounceVertical = false
    
    // Hide colors and separators from the navigation bar
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
    navigationItem.rightBarButtonItems = [ UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(RecipeExpandingTableViewController.deleteRecipe)), UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(RecipeExpandingTableViewController.updateRecipe))]
    navigationItem.rightBarButtonItems?.forEach { $0.tintColor = .hyperOrange }

    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Cross"), style: .plain, target: self, action: #selector(RecipeExpandingTableViewController.popTransitionAnimation))
    navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
  }
  
  // MARK: - User Interaction
  
  func updateRecipe() {
    if let recipeController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeFormViewController") as? RecipeFormViewController {
      recipeController.viewModel.recipe = recipe
      
      recipeController.formDidCancel.asObserver().subscribe(onNext: {
        recipeController.dismiss(animated: true, completion: nil)
      }).addDisposableTo(disposeBag)
      
      recipeController.didUpdateRecipe.asObserver().subscribe(onNext: { updatedRecipe in
        self.recipe.0 = updatedRecipe
        self.recipeDidUpdate.onNext(updatedRecipe)
        self.tableView.reloadData()
        recipeController.dismiss(animated: true, completion: nil)
      }).addDisposableTo(disposeBag)
      
      self.present(recipeController, animated: true)
    }
  }
  
  func deleteRecipe() {
    popTransitionAnimation()
    recipeDidDelete.onNext(recipe.0)
  }
}

// MARK: - Table View delegate

extension RecipeExpandingTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  private struct SectionCell {
    static let headerIdentifier = "RecipeDetailHeaderSectionCell"
    static let cellIdentifier = "RecipeDetailSectionCell"
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: SectionCell.headerIdentifier, for: indexPath) as! RecipeDetailHeaderSectionCell
      cell.titleLabel.text = recipe.0.name
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: SectionCell.cellIdentifier, for: indexPath) as! RecipeDetailSectionCell
      
      if indexPath.section == 1 {
        cell.titleLabel.text = "Description"
        cell.descriptionLabel.text = recipe.0.description
        
      } else if indexPath.section == 2 {
        cell.titleLabel.text = "Instructions"
        cell.descriptionLabel.text = recipe.0.instructions
      }
      
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 20.0 : 0.0
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == 0 ? 20.0 : 0.0
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 85 : 125
  }
}

