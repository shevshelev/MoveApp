//
//  MainPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

struct MainPresenterDataStore {
    let nowPlaying: [MovieModelProtocol]
    let topRatedFilms: [MovieModelProtocol]
    let popularMFilms: [MovieModelProtocol]
    let popularTv: [MovieModelProtocol]
    let topRatedTv: [MovieModelProtocol]

}

final class MainPresenter: MainViewControllerOutputProtocol {
    
    private unowned let view: MainViewControllerInputProtocol
//    private var dataStore: MainPresenterDataStore?
    var interactor: MainInteractorInputProtocol!
    
    init(view: MainViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObjects()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
    func objectsDidReceive(with dataStore: MainPresenterDataStore) {
        
        let sections: [MovieSectionViewModel] = [
            MovieSectionViewModel(type: .nowPlaying, items: dataStore.nowPlaying),
            MovieSectionViewModel(type: .topRatedFilms, items: dataStore.topRatedFilms),
            MovieSectionViewModel(type: .popularFilms, items: dataStore.popularMFilms),
            MovieSectionViewModel(type: .topRatedTV, items: dataStore.topRatedTv),
            MovieSectionViewModel(type: .popularTV, items: dataStore.popularTv)
        ]
        self.view.reloadData(for: sections)
        
    }
    
    
}
