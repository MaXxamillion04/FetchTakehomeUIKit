//
//  ErrorCell.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/29/24.
//

import UIKit

class ErrorCell: UICollectionViewCell {
    
    
    @IBOutlet weak var errorTitle: UILabel!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    func setErrorTitleHidden(_ hidden: Bool) {
        errorTitle.isHidden = hidden
    }
    
    func setErrorMessage(_ text: String) {
        errorMessageLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        errorTitle.isHidden = false
        errorMessageLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
