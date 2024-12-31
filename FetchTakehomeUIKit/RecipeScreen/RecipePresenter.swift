//
//  RecipePresenter.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/13/24.
//
import UIKit

//Presenter passes data into ViewController for presentation
//also manages navigation to new screens
//contains the module, which is the entry point to the screen and injects the relationship of various parts of VIP
protocol RecipePresentable {
    func viewLoaded()
    func refreshRecipes()
    func displayImageForRecipe(_ recipe: RecipeEntity, completion: @escaping (UIImage?) -> Void)
}

class RecipePresenter: RecipePresentable {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<RecipePresenter.Section, RecipePresenter.Item>
    var snapshot: Snapshot = .init() {
        didSet {
            viewController?.displaySnapshot(snapshot)
        }
    }
    
    enum Section: Hashable, CaseIterable {
        case errorSection
        case recipeSection
    }
    
    enum Item: Hashable, Equatable {
        case recipe(RecipeEntity)
        case errorMessage(RecipeError)
    }
    
    weak var viewController: RecipeViewControllable?
    var interactor: RecipeInteractable
    
    init(interactor: RecipeInteractable) {
        self.interactor = interactor
    }
    
    func viewLoaded() {
        viewController?.setTitle("Recipe List")
        refreshRecipes()
    }
    
    func refreshRecipes() {
        Task {
            await interactor.fetchRecipes()
            updateSnapshot()
        }
    }
    
    //update UI with new data
    func updateSnapshot() {
        var snapshot = Snapshot()
        
        if let error = interactor.errorState {
            snapshot.appendSections([.errorSection])
            snapshot.appendItems([.errorMessage(error)], toSection: .errorSection)
        } else {
            snapshot.appendSections([.recipeSection])
            snapshot.appendItems(interactor.recipes.map { .recipe($0) }, toSection: .recipeSection)
        }
        
        self.snapshot = snapshot
    }
    
    func displayImageForRecipe(_ recipe: RecipeEntity,  completion: @escaping (UIImage?) -> Void) {
        Task {
            do {
                let image = try await interactor.fetchImage(for: recipe)
                completion(image)
            } catch {
                // potential for handling more nuanced errors like network issues, image decoding issues, etc. Out of scope for this assignment. For now we will just nil the image, and display a systemImage instead.
                completion(nil)
            }
        }
    }
    
}

extension RecipePresenter {
    static func module() -> UIViewController {
        let interactor = RecipeInteractor()
        let presenter = RecipePresenter(interactor: interactor)
        let viewController = RecipeViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }
}
