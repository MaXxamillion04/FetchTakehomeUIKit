//
//  MockNetworkService.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//

@testable import FetchTakehomeUIKit
import UIKit

class MockNetworkService: NetworkServiceProtocol {
    
    var setURLToDefaultClosure: ((FetchTakehomeUIKit.NetworkService.DefaultURL) -> ())?
    func setURLToDefault(_ url: FetchTakehomeUIKit.NetworkService.DefaultURL) {
        setURLToDefaultClosure?(url)
    }
    
    var fetchRecipesClosure: (() async throws -> (FetchTakehomeUIKit.RecipeListDTO))?
    func fetchRecipes() async throws -> FetchTakehomeUIKit.RecipeListDTO {
        try await fetchRecipesClosure!()
    }
    
    var fetchImageFromUrlStringClosure: ((String) async throws -> (UIImage?))?
    func fetchImageFromUrlString(_ urlString: String) async throws -> UIImage? {
        try await fetchImageFromUrlStringClosure?(urlString)
    }
    
    
}
