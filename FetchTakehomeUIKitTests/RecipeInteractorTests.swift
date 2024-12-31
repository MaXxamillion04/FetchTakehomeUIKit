//
//  RecipeInteractorTests.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//

@testable import FetchTakehomeUIKit
import XCTest

class RecipeInteractorTests: XCTestCase {
    
    var sut: RecipeInteractor!
    
    var networkService: MockNetworkService!
    var imagesService: MockImagesService!
    
    override func setUp() {
        networkService = .init()
        imagesService = .init()
        sut = .init(networkService: networkService, imagesService: imagesService)
    }
    
    func testFetchRecipes_withSuccess() async {
        
        XCTAssert(sut.recipes.isEmpty)
        XCTAssertNil(sut.errorState)
        
        let expectation1 = expectation(description: "networkService is called")
        networkService.fetchRecipesClosure = {
            expectation1.fulfill()
            return RecipeListDTO.mockSuccess
        }
        
        await sut.fetchRecipes()
        
        await fulfillment(of: [expectation1], timeout: 0.1)
        
        XCTAssertFalse(sut.recipes.isEmpty)
        XCTAssertEqual(sut.recipes.first?.name, "some")
        XCTAssertNil(sut.errorState)
    }
    
    func testFetchRecipes_withEmptyData() async {
        XCTAssert(sut.recipes.isEmpty)
        XCTAssertNil(sut.errorState)
        
        let expectation1 = expectation(description: "networkService is called")
        networkService.fetchRecipesClosure = {
            expectation1.fulfill()
            return RecipeListDTO.mockEmpty
        }
        
        await sut.fetchRecipes()
        
        await fulfillment(of: [expectation1], timeout: 0.1)
        
        XCTAssert(sut.recipes.isEmpty)
        XCTAssertEqual(sut.errorState, RecipeError.emptyData)
    }
    
    func testFetchRecipes_withMalformedData() async {
        XCTAssert(sut.recipes.isEmpty)
        XCTAssertNil(sut.errorState)
        
        let expectation1 = expectation(description: "networkService is called")
        networkService.fetchRecipesClosure = {
            expectation1.fulfill()
            throw RecipeError.malformedData
        }
        
        await sut.fetchRecipes()
        
        await fulfillment(of: [expectation1], timeout: 0.1)
        
        XCTAssert(sut.recipes.isEmpty)
        XCTAssertEqual(sut.errorState, RecipeError.malformedData)
    }
    
    func testFetchImage_withLargeImageUrl() async {
        let recipe: RecipeEntity = .mock
        
        let expectation1 = expectation(description: "image service should be called")
        imagesService.fetchImageFromUrlStringClosure = { urlString in
            XCTAssertEqual(urlString, "large") // see mock data below
            expectation1.fulfill()
            return UIImage(systemName: "xmark")
        }
        
        do {
            let image = try await self.sut.fetchImage(for: recipe)
            XCTAssertEqual(image, UIImage(systemName: "xmark"))
        } catch {
            XCTFail("unexpected error")
        }
        
        await fulfillment(of: [expectation1], timeout: 0.1)
    }
    
    func testFetchImage_withOnlySmallImageUrl() async {
        let recipe: RecipeEntity = .smallUrlOnly
        
        let expectation1 = expectation(description: "image service should be called")
        imagesService.fetchImageFromUrlStringClosure = { urlString in
            XCTAssertEqual(urlString, "small") // see mock data below
            expectation1.fulfill()
            return UIImage(systemName: "xmark")
        }
        
        do {
            let image = try await self.sut.fetchImage(for: recipe)
            XCTAssertEqual(image, UIImage(systemName: "xmark"))
        } catch {
            XCTFail("unexpected error")
        }
        
        await fulfillment(of: [expectation1], timeout: 0.1)
    }
    
    func testFetchImage_withImageServiceError() async {
        let recipe: RecipeEntity = .smallUrlOnly
        
        let expectation1 = expectation(description: "image service should be called")
        imagesService.fetchImageFromUrlStringClosure = { urlString in
            XCTAssertEqual(urlString, "small") // see mock data below
            expectation1.fulfill()
            throw ImagesError.otherError
        }
        
        do {
            let image = try await self.sut.fetchImage(for: recipe)
            XCTFail("expected error")
        } catch {
            let imagesError = error as? ImagesError
            XCTAssertEqual(imagesError, ImagesError.otherError)
        }
        
        await fulfillment(of: [expectation1], timeout: 0.1)
    }
    
    func testFetchImage_withNoImageUrl() async {
        let recipe: RecipeEntity = .noImageUrl
        
        let expectation1 = expectation(description: "image service should not be called")
        expectation1.isInverted = true
        imagesService.fetchImageFromUrlStringClosure = { urlString in
            expectation1.fulfill()
            throw ImagesError.otherError // shouldnt be called
        }
        
        do {
            let image = try await self.sut.fetchImage(for: recipe)
            XCTFail("expected error")
        } catch {
            let imagesError = error as? ImagesError
            XCTAssertEqual(imagesError, ImagesError.noImage)
        }
        
        await fulfillment(of: [expectation1], timeout: 0.1)
    }
}

extension RecipeEntity {
    static var mock: Self {
        .init(cuisine: "some",
                              name: "some",
                              photo_url_large: "large",
                              photo_url_small: "small",
                              uuid: "some",
                              source_url:
                                "some",
                              youtube_url: "some")
    }
    
    static var smallUrlOnly: Self {
        .init(cuisine: "some",
                              name: "some",
                              photo_url_large: nil,
                              photo_url_small: "small",
                              uuid: "some",
                              source_url:
                                "some",
                              youtube_url: "some")
    }
    
    static var noImageUrl: Self {
        .init(cuisine: "some",
                              name: "some",
                              photo_url_large: nil,
                              photo_url_small: nil,
                              uuid: "some",
                              source_url:
                                "some",
                              youtube_url: "some")
    }
}

extension RecipeListDTO {
    static var mockSuccess: Self {
        .init(recipes: [.init(cuisine: "some",
                              name: "some",
                              photo_url_large: "some",
                              photo_url_small: "some",
                              uuid: "some",
                              source_url:
                                "some",
                              youtube_url: "some")])
    }
    
    static var mockEmpty: Self {
        .init(recipes: [])
    }
}
