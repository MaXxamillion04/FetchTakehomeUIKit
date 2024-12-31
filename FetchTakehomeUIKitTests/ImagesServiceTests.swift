//
//  Untitled.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//

@testable import FetchTakehomeUIKit
import XCTest

class ImagesServiceTests: XCTestCase {

    var sut: ImagesService!
    
    var networkService: MockNetworkService!
    
    override func setUp() {
        networkService = .init()
        sut = .init(networkService: networkService)
    }
    
    func testFetchImageFromUrlString_withCacheMiss_thenCacheHit() async {
        
        //part 1: cache miss on url string, calls network service for image
        let urlString = "test"
        
        let expectation1 = expectation(description: "network service is called")
        networkService.fetchImageFromUrlStringClosure = { urlString in
            XCTAssertEqual(urlString, "test")
            expectation1.fulfill()
            return UIImage(systemName: "xmark")
        }
        
        do {
            let image = try await self.sut.fetchImageFromUrlString(urlString)
            XCTAssertEqual(image, UIImage(systemName: "xmark"))
        } catch {
            XCTFail("unexpected error")
        }
        
        await fulfillment(of: [expectation1], timeout: 0.1)
        
        //part 2: cache hit on same urlString
        networkService.fetchImageFromUrlStringClosure = { urlString in
            XCTAssertEqual(urlString, "test")
            throw ImagesError.noImage
        }
        
        let expectation2 = expectation(description: "network service should not be called again due to cache hit")
        expectation2.isInverted = true
        
        networkService.fetchImageFromUrlStringClosure = { urlString in
            XCTAssertEqual(urlString, "test")
            expectation2.fulfill()
            throw ImagesError.noImage
        }
        
        do {
            let image = try await self.sut.fetchImageFromUrlString(urlString)
            XCTAssertEqual(image, UIImage(systemName: "xmark"))
        } catch {
            XCTFail("unexpected error")
        }
        
        await fulfillment(of: [expectation2], timeout: 0.1)
    }
    
    func testFetchImageFromUrlString_withNetworkError() async {
        
        let urlString = "test"
        
        let expectation1 = expectation(description: "network service is called")
        networkService.fetchImageFromUrlStringClosure = { urlString in
            XCTAssertEqual(urlString, "test")
            expectation1.fulfill()
            throw ImagesError.otherError
        }
        
        do {
            let image = try await self.sut.fetchImageFromUrlString(urlString)
            XCTFail("expected error")
        } catch {
            let imageError = error as? ImagesError
            XCTAssertEqual(imageError, ImagesError.otherError)
        }
        
        await fulfillment(of: [expectation1], timeout: 0.1)
    }
}
