//
//  BaseViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import UIKit

class BaseViewController: UIViewController, UICollectionViewDelegate {
    
    private var tabBarIsHidden: Bool = false
    private let backgroundColor = UIColor(
        red: 89 / 255,
        green: 41 / 255,
        blue: 149 / 255,
        alpha: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupNavBar()
    }
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 30)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 60)
        ]
        navBarAppearance.backgroundColor = backgroundColor
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = backgroundColor
        collectionView.delegate = self
        collectionView.registerCells([MainMovieCell(), MainNowPlayingMovieCell()], and: MainMovieSection())
    }
}

// MARK: - UIScrollViewDelegate

extension BaseViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let tabbar = tabBarController as? TabBarController
        tabBarIsHidden.toggle()
        tabbar?.setTabBarHidden(tabBarIsHidden, animated: true)
    }
}
