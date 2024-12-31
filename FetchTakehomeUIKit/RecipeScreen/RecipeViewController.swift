//
//  ViewController.swift
//  FetchTakehomeUIKit
//
//  Created by MaXx Speller on 12/13/24.
//

import UIKit

//ViewController, holds and arranges all UI elements
//holds strong reference to presenter, uses this to pass UI interaction to presenter(only example here is refresh button)

protocol RecipeViewControllable: UIViewController {
    func setTitle(_ title: String)
    func displaySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<RecipePresenter.Section, RecipePresenter.Item>)
}

class RecipeViewController: UIViewController, RecipeViewControllable {
    
    //used to refresh elements on screen
    let refreshControl = UIRefreshControl()
    lazy var gridView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: (view.frame.width - 32 - 16) / 4, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    var presenter: RecipePresentable
    
    var dataSource: UICollectionViewDiffableDataSource<RecipePresenter.Section, RecipePresenter.Item>!
    
    init(presenter: RecipePresentable) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }
    
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        #if DEBUG
        setupConvenienceButtons()
        #endif
        setupRefreshButton()
        setupCollectionView()
        presenter.viewLoaded()
    }
    
    func displaySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<RecipePresenter.Section, RecipePresenter.Item>) {
        DispatchQueue.main.async { [ weak self] in
            self?.refreshControl.endRefreshing()
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func setupConvenienceButtons() {
        navigationItem.setLeftBarButtonItems([.init(barButtonSystemItem: .bookmarks, target: self, action: #selector(setURLToWorking)),
                                               .init(barButtonSystemItem: .organize, target: self, action: #selector(setURLToEmpty)),
                                              .init(barButtonSystemItem: .trash, target: self, action: #selector(setURLToMalformed))],
                                             animated: false)
    }
    
    @objc private func setURLToWorking() {
        NetworkService.shared.setURLToDefault(.working)
    }
    
    @objc private func setURLToEmpty() {
        NetworkService.shared.setURLToDefault(.empty)
    }
    
    @objc private func setURLToMalformed() {
        NetworkService.shared.setURLToDefault(.malformed)
    }
    
    private func setupRefreshButton() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
    }
    
    private func setupCollectionView() {
        view.addSubview(gridView)
        
        gridView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            gridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        print("registering cells")
        gridView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCell")
        gridView.register(UINib(nibName: "ErrorCell", bundle: nil), forCellWithReuseIdentifier: "ErrorCell")
        
        dataSource = UICollectionViewDiffableDataSource<RecipePresenter.Section, RecipePresenter.Item>(collectionView: gridView) { [weak self] collectionView, indexPath, item in
            switch item {
            case .errorMessage(let errorMessage):
                guard let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCell", for: indexPath) as? ErrorCell else { print("error dequeuing error cell"); return UICollectionViewCell() }
                
                errorCell.setErrorMessage(errorMessage.associatedText)
                errorCell.setErrorTitleHidden(errorMessage.errorTitleIsHidden)
                
                return errorCell
                
            case .recipe(let recipe):
                guard let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as? RecipeCell else { print("error dequeuing recipe cell"); return UICollectionViewCell() }
                
                recipeCell.setCuisineText(recipe.cuisine)
                recipeCell.setRecipeNameText(recipe.name)
                recipeCell.setImage(image: UIImage(systemName: "ellipsis.rectangle"))
                self?.presenter.displayImageForRecipe(recipe) { image in
                    DispatchQueue.main.async {
                        recipeCell.setImage(image: image ?? UIImage(systemName: "xmark.square.fill"))
                    }
                }
                
                return recipeCell
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    
    
    @objc func refreshData() {
        presenter.refreshRecipes()
    }
}

extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let section = dataSource.sectionIdentifier(for: indexPath.section) {
            switch section {
            case .errorSection: return CGSize(width: view.frame.width, height: 200.0)
            case .recipeSection:
                let width = (view.frame.width - 32.0) / 3
                
                return CGSize(width: width, height: width + 120)
            }
        } else {
            return CGSize(width: 300.0, height: 300.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    
}
