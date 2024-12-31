//
//  MockImagesService.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//

@testable import FetchTakehomeUIKit
import UIKit

class MockImagesService: ImagesServiceProtocol {
    var fetchImageFromUrlStringClosure: ((String) async throws ->(UIImage?))?
    func fetchImageFromUrlString(_ urlString: String) async throws -> UIImage? {
        try await fetchImageFromUrlStringClosure?(urlString)
    }
    
    
}
