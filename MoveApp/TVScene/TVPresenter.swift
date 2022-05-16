//
//  TVPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 16.05.2022.
//

import Foundation

struct TVPresenterDataStore {
    let latest: MovieModelProtocol
    let onAir: [MovieModelProtocol]
    let airingToday: [MovieModelProtocol]
    let popular: [MovieModelProtocol]
    let topRated: [MovieModelProtocol]
}

final class TVPresenter: MainViewControllerOutputProtocol {
    
    private unowned let view: MainViewControllerInputProtocol
    var interactor: TVInteractorInputProtocol!
    
    init(view: MainViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        print("456")
        interactor.fetchObjects()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        
    }
}

extension TVPresenter: TVInteractorOutputProtocol {
    func objectsDidReceive(with dataStore: TVPresenterDataStore) {
        let sections: [MovieSectionViewModel] = [
            MovieSectionViewModel(type: .latest, item: dataStore.latest),
            MovieSectionViewModel(type: .nowPlaying, items: dataStore.onAir),
            MovieSectionViewModel(type: .airingToday, items: dataStore.airingToday),
            MovieSectionViewModel(type: .popular, items: dataStore.popular),
            MovieSectionViewModel(type: .topRated, items: dataStore.topRated)
        ]
        print("123")
        view.reloadData(for: sections)
    }
}
