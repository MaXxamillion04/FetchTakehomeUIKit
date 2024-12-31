//
//  RecipeError.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/28/24.
//

enum RecipeError: Error {
    case emptyData
    case malformedData
    case otherError
    
    var associatedText: String {
        switch self {
        case .emptyData: "There were no recipes found! You may refresh to try again, but it may not fix the issue."
        case .malformedData: "The data was not in the expected format! You may refresh to try again, but it may not fix the issue."
        case .otherError: "There was an unexpected error! You may refresh to try again."
        }
    }
    
    var errorTitleIsHidden: Bool {
        switch self {
        case .emptyData: true
        default: false
        }
    }
}
