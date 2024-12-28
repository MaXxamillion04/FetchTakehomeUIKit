//
//  NetworkManager.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/17/24.
//

import UIKit
import Foundation

protocol NetworkServiceProtocol {
    func fetchRecipes() throws -> RecipeListDTO
    func fetchImageFromUrlString(_ urlString: String) throws -> UIImage
}

class NetworkService: NetworkServiceProtocol {
    static var shared: NetworkService = .init()
    
    init() {}
    
    func fetchRecipes() throws -> RecipeListDTO  {
        <#code#>
    }
    
    func fetchImageFromUrlString(_ urlString: String) throws -> UIImage {
        <#code#>
    }
    
    
}
