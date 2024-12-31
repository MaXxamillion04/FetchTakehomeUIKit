//
//  MockRecipeInteractor.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//

@testable import FetchTakehomeUIKit
import UIKit

class MockRecipeInteractor: RecipeInteractable {
    var fetchRecipesClosure: (() async -> Void)?
    func fetchRecipes() async {
        await fetchRecipesClosure?()
    }
    
    var fetchImageClosure: ((FetchTakehomeUIKit.RecipeEntity) async throws -> UIImage?)?
    func fetchImage(for recipe: FetchTakehomeUIKit.RecipeEntity) async throws -> UIImage? {
        try await fetchImageClosure?(recipe)
    }
    
    var underlyingRecipes: [FetchTakehomeUIKit.RecipeEntity]!
    var recipes: [FetchTakehomeUIKit.RecipeEntity] {
        underlyingRecipes
    }
    
    var errorState: FetchTakehomeUIKit.RecipeError?
}
