//
//  ImagesService.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/28/24.
//

import UIKit

//Our images service is meant to handle cacheing of images, as well as fetching from remote in event of a cache miss
protocol ImagesServiceProtocol {
    func fetchImageFromUrlString(_ urlString: String) -> Result<UIImage, ImagesError>
}

class ImagesService: ImagesServiceProtocol {
    static let shared: ImagesService = .init()
    
    var cache: [String: UIImage]
    var networkManager: NetworkManagerProtocol
    
    init() {
        
    }
    
    func fetchImageFromUrlString(_ urlString: String) -> Result<UIImage, ImagesError> {
        <#code#>
    }
    
    
}

enum ImagesError: Error {
    
}
