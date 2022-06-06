//
//  BaseViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import UIKit

class BaseViewController: UIViewController, UICollectionViewDelegate {
    
    private lazy var tabbar = tabBarController as? TabBarController
    private var tabBarIsHidden: Bool = false
    private let backgroundColor = UIColor(
        red: 89 / 255,
        green: 41 / 255,
        blue: 149 / 255,
        alpha: 1
    )
    
    var baseScrollView: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = backgroundColor
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backButtonAppearance = UIBarButtonItemAppearance()
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 30)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 60)
        ]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
    
    func showTabBar() {
        if tabBarIsHidden {
            tabBarIsHidden = false
            tabbar?.setTabBarHidden(tabBarIsHidden, animated: true)
        }
    }
    
    func setupBaseCollectionView(_ collectionView: UICollectionView) {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        baseScrollView = collectionView
        collectionView.backgroundColor = backgroundColor
        collectionView.delegate = self
        collectionView.registerCells([MovieCell(), MovieBigCell()], and: MovieCollectionSection())
    }
    
    func createDataSource<S: Hashable, T: Hashable>(_ sectionType: S.Type, _ itemsType: T.Type, for collectionView: UICollectionView, with cellProvider: @escaping ((UICollectionView, IndexPath, T) -> UICollectionViewCell?)) -> UICollectionViewDiffableDataSource<S, T> {
       let dataSource = UICollectionViewDiffableDataSource<S, T>(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
        return dataSource
    }
    
    func createSupplementaryViewProvider<S: Hashable & MovieSectionViewModelProtocol, T: Hashable>(for dataSource: UICollectionViewDiffableDataSource<S, T>?, with view: MovieCollectionSection) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
           guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: view.reuseId,
                for: indexPath
           ) as? MovieCollectionSection else { return nil }

            guard let firstMovie = dataSource?
                .itemIdentifier(for: indexPath) else { return nil }
            guard let viewModel = dataSource?.snapshot()
                .sectionIdentifier(containingItem: firstMovie) else { return nil }
            sectionHeader.viewModel = viewModel
            return sectionHeader
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
}

// MARK: - UIScrollViewDelegate

extension BaseViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == baseScrollView {
            tabBarIsHidden.toggle()
            tabbar?.setTabBarHidden(tabBarIsHidden, animated: true)
        }
    }

}
