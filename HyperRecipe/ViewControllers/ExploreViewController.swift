//
//  ExploreViewController.swift.swift
//  HyperRecipe
//
//  Created by Rebouh Aymen on 19/01/2017.
//  Copyright © 2017 Aymen Rebouh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RxSwift
import RxCocoa
import expanding_collection

class ExploreViewController: ExpandingViewController {
  
  // MARK: - Properties
  
  let disposeBag = DisposeBag()
  
  // @Inject c.f DependendyInjection in the Project navigator
  var viewModel: RecipeViewModel!
  var openCells: [Bool]!
  var cachedImages: [UIImage?]!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      itemSize = CGSize(width: 485, height: 569)
    }
    
    super.viewDidLoad()
    
    let nib = UINib(nibName: String(describing: RecipeCollectionViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: RecipeCollectionViewCell.self))
    
    addGestureToView(collectionView!) // From ExpandCollection Library
    CAEmitterRecipe.animate(inView: self.view, duration: 0.3)
    
    bindViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Well, the Expand collection library seems not working if I load my recipes before the view did lod, so I do it there
    if viewModel.recipes.isEmpty {
      self.viewModel.getAllRecipes().asObservable()
        .subscribe(onNext: { recipes in
          self.cachedImages = Array(repeating: nil, count: recipes.count)
          self.openCells = Array(repeating: false, count: recipes.count)
          self.viewModel.recipes = recipes
          self.collectionView?.reloadData()
        }, onError: { error in
          print("error = \(error)")
        }).addDisposableTo(disposeBag)
    }
  }
  
  func bindViewModel() {
    viewModel.error.asObservable().skip(1).subscribe(onNext: { error in
      print("error \(error)")
    }).addDisposableTo(disposeBag)
    
    
    navigationItem.rightBarButtonItem!.rx.tap
      .asDriver()
      .drive(onNext: {
        self.showRecipeFormController()
      }).addDisposableTo(disposeBag)
  }
  
  // MARK: - User Interaction
  
  func showRecipeFormController() {
    if let recipeController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeFormViewController") as? RecipeFormViewController {
      
      recipeController.formDidCancel.asObserver().subscribe(onNext: {
        recipeController.dismiss(animated: true, completion: nil)
      }).addDisposableTo(disposeBag)
      
      recipeController.didCreateRecipe.asObserver().subscribe(onNext: { newRecipe in
        recipeController.dismiss(animated: true, completion: nil)
        let indexPath = IndexPath(row: 0, section: 0)
        self.openCells.insert(false, at: indexPath.row)
        self.cachedImages.insert(nil, at: indexPath.row)
        self.viewModel.recipes.insert(newRecipe, at: indexPath.row)
        self.collectionView?.insertItems(at: [indexPath])
        self.collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
      }).addDisposableTo(disposeBag)
      
      self.present(recipeController, animated: true)
    }
  }
}

// MARK: - CollectionView delegate

extension ExploreViewController {
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecipeCollectionViewCell.self), for: indexPath) as! RecipeCollectionViewCell
    
    let recipe = viewModel.recipes[indexPath.row]
    cell.recipe = recipe
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    
    if let cell = cell as? RecipeCollectionViewCell {
      
      let recipe = viewModel.recipes[indexPath.row]
      
      if let imagedCached = cachedImages[indexPath.row] {
        cell.recipeImageView.image = imagedCached
        
      } else {
        cell.recipeImageView.image = #imageLiteral(resourceName: "recipeBackgroundPlaceholder")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(recipe.photo.url)
          .responseImage { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let recipeimage = response.result.value {
              self.cachedImages[indexPath.row] = recipeimage
              cell.recipeImageView.image = recipeimage
            } else {
              print("error downloading image \(recipe.photo.url)")
            }
        }
      }
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.recipes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell  = collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell else { return }
    
    if cell.isOpened == true {
      showDetail(ofCell: cell, atIndex: indexPath)
      
    } else {
      // if the cell is not open, we open it
      cell.cellIsOpen(true)
    }
    
    self.openCells[indexPath.row] = cell.isOpened
  }
  
  func showDetail(ofCell cell: RecipeCollectionViewCell, atIndex indexPath: IndexPath) {
    if let tableController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeExpandingTableViewController") as? RecipeExpandingTableViewController {
      tableController.recipe = (viewModel.recipes[indexPath.row], cachedImages[indexPath.row])
      tableController.recipeDidDelete.asObservable()
        .subscribe(onNext: { recipe in
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.openCells.remove(at: indexPath.row)
            self.cachedImages.remove(at: indexPath.row)
            self.viewModel.recipes.remove(at: indexPath.row)
            self.collectionView?.deleteItems(at: [indexPath])
          }
        }).addDisposableTo(disposeBag)
      pushToViewController(tableController)
    }
  }
}

/// MARK: Gesture

extension ExploreViewController {
  
  func addGestureToView(_ toView: UIView) {
    let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(ExploreViewController.swipeHandler(_:)))
    gestureUp.direction = .up
    
    let gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(ExploreViewController.swipeHandler(_:)))
    gestureDown.direction = .down
    
    collectionView?.addGestureRecognizer(gestureUp)
    collectionView?.addGestureRecognizer(gestureDown)
  }
  
  func swipeHandler(_ swipeGesture: UISwipeGestureRecognizer) {
    let indexPath = IndexPath(row: currentIndex, section: 0)
    guard let cell  = collectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell else { return }
    
    if cell.isOpened == true && swipeGesture.direction == .up {
      showDetail(ofCell: cell, atIndex: indexPath)
    }
    
    let shouldOpen = swipeGesture.direction == .up
    cell.cellIsOpen(shouldOpen)
    openCells[currentIndex] = cell.isOpened
  }
}

