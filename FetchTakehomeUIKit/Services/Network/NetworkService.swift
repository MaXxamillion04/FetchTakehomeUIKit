//
//  NetworkManager.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/17/24.
//

import UIKit
import Foundation

protocol NetworkServiceProtocol {
    func setURLToDefault(_ url: NetworkService.DefaultURL)
    func fetchRecipes() async throws -> RecipeListDTO
    func fetchImageFromUrlString(_ urlString: String) async throws -> UIImage?
}

class NetworkService: NetworkServiceProtocol {
    static var shared: NetworkService = .init()
    
    var currentURL: DefaultURL
    
    //convenience for testing different urls
    enum DefaultURL: String {
        case working = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    }
    
    func setURLToDefault(_ url: DefaultURL) {
        currentURL = url
    }
    
    init() {
        currentURL = .working
    }
    
    func fetchRecipes() async throws -> RecipeListDTO  {
        guard let url = URL(string: currentURL.rawValue) else { print("error decoding url from preset URL"); throw NetworkError.badURL }
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let result = try JSONDecoder().decode(RecipeListDTO.self, from: data)
            return result
        } catch {
            throw RecipeError.malformedData
        }
    }
    
    func fetchImageFromUrlString(_ urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { throw NetworkError.badURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let image = UIImage(data: data)
        return image
    }
    
    
}

enum NetworkError: Error {
    case badURL
    case someError
}
