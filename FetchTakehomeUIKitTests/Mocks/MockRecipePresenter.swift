//
//  MockRecipePresenter.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//

@testable import FetchTakehomeUIKit
import UIKit

//This mocking is best done with an auto-mocking tool such as Sourcery
class MockRecipePresenter: RecipePresentable {
    var viewLoadedClosure: (() -> Void)?
    func viewLoaded() {
        viewLoadedClosure?()
    }
    
    var refreshRecipesClosure: (() -> Void)?
    func refreshRecipes() {
        refreshRecipesClosure?()
    }
    
    var displayImageForRecipeClosure: ((FetchTakehomeUIKit.RecipeEntity, (UIImage?) -> Void) -> Void)?
    func displayImageForRecipe(_ recipe: FetchTakehomeUIKit.RecipeEntity, completion: @escaping (UIImage?) -> Void) {
        displayImageForRecipeClosure?(recipe, completion)
    }
}
