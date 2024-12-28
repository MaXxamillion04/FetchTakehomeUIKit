//
//  RecipeInteractor.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/13/24.
//
protocol RecipeInteractable {
    func fetchRecipes() async throws
    
    var recipes: [Recipe]
}

class RecipeInteractor: RecipeInteractable {
    
}
