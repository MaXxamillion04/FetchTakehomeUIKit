//
//  RecipeInteractor.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/13/24.
//

import UIKit

protocol RecipeInteractable {
    func fetchRecipes() async
    func fetchImage(for recipe: RecipeEntity) async throws -> UIImage?
    
    var recipes: [RecipeEntity] { get }
    
    var errorState: RecipeError? { get }
}

class RecipeInteractor: RecipeInteractable {
    
    //injected through init for mocking in unit testing
    let networkService: NetworkServiceProtocol
    let imagesService: ImagesServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService.shared,
         imagesService: ImagesServiceProtocol = ImagesService.shared) {
        self.networkService = networkService
        self.imagesService = imagesService
    }
    
    var recipes: [RecipeEntity] = []
    
    var errorState: RecipeError? = nil
    
    func fetchRecipes() async {
        do {
            let response = try await networkService.fetchRecipes()
            
            recipes = response.recipes
            if response.recipes.count == 0 {
                throw RecipeError.emptyData
            }
        } catch(let error) {
            if let recipeError = error as? RecipeError {
                errorState = recipeError
            } else {
                // Log unknown error
                print("unexpected error occurred when fetching recipes")
                errorState = RecipeError.otherError
            }
        }
    }
    
    func fetchImage(for recipe: RecipeEntity) async throws -> UIImage? {
        //fetch largest possible image for recipe image, as our implementation only displays one
        if let recipeURL = recipe.photo_url_large ?? recipe.photo_url_small {
            let image = try await imagesService.fetchImageFromUrlString(recipeURL)
            return image
        } else {
            throw ImagesError.noImage
        }
    }
}
