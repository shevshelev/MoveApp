//
//  DetilPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 18.05.2022.
//

import Foundation

struct DetailPresenterDataStore {
    let title: String
    let posterEndPoint: String?
}

class DetailPresenter: DetailViewControllerOutputProtocol {
    
    private unowned let view: DetailViewControllerInputProtocol
    var interactor: DetailInteractorInputProtocol!
    
    required init(view: DetailViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObject()
    }
    
    func didTapFavouriteButton() {
        
    }
    
    
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func objectDidReceive(with dataStore: DetailPresenterDataStore) {
        DispatchQueue.main.async {
            self.view.reloadData(with: dataStore.title, and: dataStore.posterEndPoint)
        }
    }
}
