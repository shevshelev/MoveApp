//
//  MoviePresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import Foundation

final class MoviePresenter: MainViewControllerOutputProtocol {

    unowned var view: MainViewControllerInputProtocol
    var sections: [MovieSectionViewModel] = []
    var interactor: MainInteractorInputProtocol!
    
    init(view: MainViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObjects()
    }
    
//    func didTapCell(at indexPath: IndexPath) {
//        Router.showDetail(from: view)
//    }
}

extension MoviePresenter: MainInteractorOutputProtocol {
    func objectsDidReceive(with dataStore: MainPresenterDataStore) {
        guard let latest = dataStore.latest else { return }
        sections = [
            MovieSectionViewModel(type: .latest, item: latest),
            MovieSectionViewModel(type: .nowPlaying, items: dataStore.nowPlaying),
            MovieSectionViewModel(type: .upcoming, items: dataStore.upcoming ?? []),
            MovieSectionViewModel(type: .popular, items: dataStore.popular),
            MovieSectionViewModel(type: .topRated, items: dataStore.topRated)
        ]
        
        view.reloadData(for: sections)
    }
}
