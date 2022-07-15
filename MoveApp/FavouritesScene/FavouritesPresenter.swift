//
//  FavouritesPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 07.06.2022.
//

import Foundation

struct FavouritesPresenterDataStore {
    let tvShows: [MovieModelProtocol]
    let films: [MovieModelProtocol]
}

class FavouritesPresenter: FavouritesViewControllerOutputProtocol {
   
    private var dataStore: FavouritesPresenterDataStore?
    unowned let view: FavouritesViewControllerInputProtocol
    var sections: [ExpandedSectionViewModel] = []
    var interactor: FavouritesInteractorInputProtocol!
    
    required init(view: FavouritesViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor = FavouritesInteractor(presenter: self, networkManager: NetworkManager.shared)
        interactor.fetchObjects()
    }
    func didTapCell(at indexPath: IndexPath) {
        let movie = sections[indexPath.section].items[indexPath.item]
//        Router.showDetail(from: view, for: movie.movieType, and: movie.movieId)
    }
    
}

extension FavouritesPresenter: FavouritesInteractorOutputProtocol {
    func objectsDidReceive(with dataStore: FavouritesPresenterDataStore) {
        sections = [
            ExpandedSectionViewModel(type: .favouritesFilms, items: dataStore.films, isExpanded: true, number: 0),
            ExpandedSectionViewModel(type: .favouritesTV, items: dataStore.tvShows, isExpanded: true, number: 1)
        ]
       
            view.reloadData(for: self.sections)
        
    }
}
