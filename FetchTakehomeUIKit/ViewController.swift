//
//  ViewController.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/13/24.
//

import UIKit

class RecipeViewController: UIViewController {
    
    var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        label.text = "Hello World"
        view.addSubview(label)
    }


}

