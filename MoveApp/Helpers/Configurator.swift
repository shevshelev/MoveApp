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
}

class Configurator: CoufiguratorInputProtocol {
    
    private let backgroundColor = UIColor.blue
    
    static func configureMainViewController(with title: String, and imageName: String) -> UINavigationController {
        let viewController = MainViewController()
        let presenter = MainPresenter(view: viewController)
        let interactor = MainInteractor(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        viewController.title = title
        viewController.presenter = presenter
        presenter.interactor = interactor
        return navigationController
    }
    
    
}
