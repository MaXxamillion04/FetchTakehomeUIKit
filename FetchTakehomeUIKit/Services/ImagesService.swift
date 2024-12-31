//
//  ImagesService.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/28/24.
//

import UIKit

// Images service is meant to handle cacheing of images, as well as fetching from remote in event of a cache miss
protocol ImagesServiceProtocol {
    func fetchImageFromUrlString(_ urlString: String) async throws -> UIImage?
}


class ImagesService: ImagesServiceProtocol, @unchecked Sendable {
    static let shared: ImagesService = .init()
    
    var cache = NSCache<NSString, UIImage>()
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchImageFromUrlString(_ urlString: String) async throws -> UIImage? {
        if let cacheImage = cache.object(forKey: urlString as NSString) {
            return cacheImage
        }
        
        do {
            let image = try await networkService.fetchImageFromUrlString(urlString)
            if let image {
                cache.setObject(image, forKey: urlString as NSString)
            }
            
            return image
        } catch {
            throw ImagesError.otherError
        }
    }
}

enum ImagesError: Error {
    case noImage
    case otherError
}
