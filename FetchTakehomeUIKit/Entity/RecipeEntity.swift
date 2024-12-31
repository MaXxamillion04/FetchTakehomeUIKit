//
//  RecipeEntity.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/17/24.
//

struct RecipeEntity: Decodable, Equatable, Hashable {
    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String
    let source_url: String?
    let youtube_url: String?
}
