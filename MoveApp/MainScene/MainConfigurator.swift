//
//  MainConfigurator.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

protocol MainCoufiguratopInputProtocol {
    func configure(with viewController: MainViewController)
}

class MainConfigurator: MainCoufiguratopInputProtocol {
    func configure(with viewController: MainViewController) {
        let presenter = MainPresenter(view: viewController)
        let interactor = MainInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
    }
    
    
}
