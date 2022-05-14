//
//  TabBarController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    lazy var mainVC = setupVC(VC: MainViewController(), title: "Main", imageName: "house")
    lazy var moviesVC = setupVC(VC: MovieViewController(), title: "Movies", imageName: "tv")
    lazy var tvVC = setupVC(VC: TVViewController(), title: "Serials", imageName: "sparkles.tv")
    lazy var favouritesVC = setupVC(VC: FavouritesViewController(), title: "Favourites", imageName: "heart")
    lazy var searchVC = setupVC(VC: SearchViewController(), title: "Search", imageName: "magnifyingglass")

    lazy var customTabBar = CustomTabBar()
    
    var tabBarHeight: CGFloat {
        customTabBar.preferredTabBarHeight
    }
    
    
    override var selectedViewController: UIViewController? {
        didSet {
            customTabBar.select(at: selectedIndex, animated: false, notifyDelegate: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isHidden = true
        setViewControllers([mainVC, moviesVC, tvVC, favouritesVC, searchVC], animated: false)
        
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTabBar.set(items: tabBar.items ?? [])
        customTabBar.select(at: selectedIndex, animated: false, notifyDelegate: true)
    }
    
    private func setupTabBar() {
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
        
        customTabBar.delegate = self
        view.addSubviews([
            customTabBar,
        ])
        
        NSLayoutConstraint.activate([
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: tabBarHeight),
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.bringSubviewToFront(customTabBar)

    }
        
    func setTabBarHidden(_ isHidden: Bool, animated: Bool) {
        let blok = {
            self.customTabBar.frame = self.customTabBar.frame.offsetBy(dx: 0, dy: isHidden ? 100 : -100)
        }
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: blok, completion: nil)
        } else {
            blok()
        }
    }
    
    private func setupVC (VC: UIViewController, title: String, imageName: String) -> UINavigationController {
        VC.title = title
        let navigationController = UINavigationController(rootViewController: VC)
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        return navigationController
    }
}

extension TabBarController: TabBarDelegate {
    func tabBar(_sender: CustomTabBar, didSelectItemAt index: Int) {
        selectedIndex = index
    }
}
