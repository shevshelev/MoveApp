//
//  MainConfigurator.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation
import UIKit

protocol CoufiguratorInputProtocol {
    static func configureMainViewController(with title: String, and imageName: String) -> UINavigationController
    static func configureMovieViewController(with title: String, and imageName: String) -> UINavigationController
    static func configureTVViewController(with title: String, and imageName: String) -> UINavigationController
}

class Configurator: CoufiguratorInputProtocol {
    
    static func configureMainViewController(with title: String, and imageName: String) -> UINavigationController {
        let viewController = MainViewController(includeLatest: false)
        let presenter = MainPresenter(view: viewController)
        let interactor = MainInteractor(presenter: presenter, networkManager: NetworkManager.shared)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        viewController.title = title
        viewController.presenter = presenter
        presenter.interactor = interactor
        return navigationController
    }
    
    static func configureMovieViewController(with title: String, and imageName: String) -> UINavigationController {
        let viewController = MainViewController(includeLatest: true)
        let presenter = MoviePresenter(view: viewController)
        let interactor = MovieInteractor(presenter: presenter, networkManager: NetworkManager.shared)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        viewController.title = title
        viewController.presenter = presenter
        presenter.interactor = interactor
        return navigationController
    }
    
    static func configureTVViewController(with title: String, and imageName: String) -> UINavigationController {
        let viewController = MainViewController(includeLatest: true)
        let presenter = TVPresenter(view: viewController)
        let interactor = TVInteractor(presenter: presenter, networkManager: NetworkManager.shared)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        viewController.title = title
        viewController.presenter = presenter
        presenter.interactor = interactor
        return navigationController
    }
    
    static func configureDetailViewController(for type: MovieType, and id: Int?) -> DetailViewController {
        let detailVC = DetailViewController()
        let presenter = DetailPresenter(view: detailVC)
        let interactor = DetailInteractor(
            id: id,
            movieType: type,
            presenter: presenter,
            networkManager: NetworkManager.shared)
        detailVC.presenter = presenter
        presenter.interactor = interactor
        return detailVC
    }
    
}
