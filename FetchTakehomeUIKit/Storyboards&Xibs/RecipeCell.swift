//
//  RecipeCell.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//
import UIKit

class RecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var cuisineLabel: UILabel!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    func setImage(image: UIImage?) {
        let image = image ?? UIImage(systemName: "xmark.square.fill")
        recipeImage.image = image
        recipeImage.isHidden = false
    }
    
    func setCuisineText(_ text: String) {
        cuisineLabel.text = text
    }
    
    func setRecipeNameText(_ text: String) {
        recipeNameLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
        recipeImage.isHidden = true
        cuisineLabel.text = "Loading..."
        recipeNameLabel.text = "Loading..."
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
    }
}
