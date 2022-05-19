//
//  TVPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 16.05.2022.
//

import Foundation

final class TVPresenter: MainViewControllerOutputProtocol {
    
    unowned let view: MainViewControllerInputProtocol
    var interactor: MainInteractorInputProtocol!
    var sections: [MovieSectionViewModel] = []
    
    init(view: MainViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObjects()
    }
}

extension TVPresenter: MainInteractorOutputProtocol {
    func objectsDidReceive(with dataStore: MainPresenterDataStore) {
        guard let latest = dataStore.latest else { return }
        sections = [
            MovieSectionViewModel(type: .latest, item: latest),
            MovieSectionViewModel(type: .nowPlaying, items: dataStore.nowPlaying),
            MovieSectionViewModel(type: .airingToday, items: dataStore.upcoming ?? []),
            MovieSectionViewModel(type: .popular, items: dataStore.popular),
            MovieSectionViewModel(type: .topRated, items: dataStore.topRated)
        ]
        view.reloadData(for: sections)
    }
}
