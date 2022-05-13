//
//  MainPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

struct MainPresenterDataStore {
    let nowPlaying: [Movie]
    let topRatedFilms: [Movie]
    let popularMFilms: [Movie]
    let popularTv: [Movie]
    let topRatedTv: [Movie]
    
}

final class MainPresenter: MainViewControllerOutputProtocol {
    
    private unowned let view: MainViewControllerInputProtocol
    private var dataStore: MainPresenterDataStore?
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
        
        let nowPlaying = dataStore.nowPlaying
        let topRatedFilms = dataStore.topRatedFilms
        let popularFilms = dataStore.popularMFilms
        let topRatedTvShows = dataStore.topRatedTv
        let popularTvShow = dataStore.popularTv
        
        
        let sections: [Section] = [
            Section(type: "nowPlaying", title: "Now Playing", items: nowPlaying),
            Section(type: "topRatedFilms", title: "Top Rated Films", items: topRatedFilms),
            Section(type: "popularFilms", title: "Popular Films", items: popularFilms),
            Section(type: "topRatedTv", title: "Top Rated TV Shows", items: topRatedTvShows),
            Section(type: "popularTv", title: "Popular TV Shows", items: popularTvShow)
        ]
        self.view.reloadData(for: sections)
        
    }
    
    
}
