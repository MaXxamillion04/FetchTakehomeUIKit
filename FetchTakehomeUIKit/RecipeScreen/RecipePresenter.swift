//
//  RecipePresenter.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/13/24.
//
import UIKit

protocol RecipePresentable {
    func viewLoaded()
}

class RecipePresenter: RecipePresentable {
    
    weak var viewController: RecipeViewControllable?
    var interactor: RecipeInteractable
    
    init(interactor: RecipeInteractable) {
        self.interactor = interactor
    }
    
    func viewLoaded() {
        // configure text on screen
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
