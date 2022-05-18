//
//  Router.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 18.05.2022.
//

import Foundation

protocol RouterInputProtocol {
    static func showDetail(from view: MainViewControllerInputProtocol, for type: MovieType, and id: Int?)
}

class Router: RouterInputProtocol {
    static func showDetail(from view: MainViewControllerInputProtocol, for type: MovieType, and id: Int?) {
        guard let fromViewController = view as? BaseViewController else { return }
        let toViewController = Configurator.configureDetailViewController(
            for: type,
            and: id
        )
        fromViewController.navigationController?.pushViewController(toViewController, animated: true)
    }
}
