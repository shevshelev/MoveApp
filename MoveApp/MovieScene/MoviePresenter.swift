//
//  MoviePresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import Foundation

struct MoviePresenterDataStore {
    let latest: MovieModelProtocol
    let nowPlaying: [MovieModelProtocol]
    let popular: [MovieModelProtocol]
    let topRated: [MovieModelProtocol]
    let upcoming: [MovieModelProtocol]
}

final class MoviePresenter: MainViewControllerOutputProtocol {
    
    private unowned let view: MainViewControllerInputProtocol
    var interactor: MovieInteractorInputProtocol!
    
    init(view: MainViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObjects()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        
    }
}

extension MoviePresenter: MovieInteractorOutputProtocol {
    func objectsDidReceive(with dataStore: MoviePresenterDataStore) {
        let sections: [MovieSectionViewModel] = [
            MovieSectionViewModel(type: .latest, item: dataStore.latest),
            MovieSectionViewModel(type: .nowPlaying, items: dataStore.nowPlaying),
            MovieSectionViewModel(type: .upcoming, items: dataStore.upcoming),
            MovieSectionViewModel(type: .popular, items: dataStore.popular),
            MovieSectionViewModel(type: .topRated, items: dataStore.topRated)
        ]
        
        view.reloadData(for: sections)
    }
    
    
}
