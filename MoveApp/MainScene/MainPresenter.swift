//
//  MainPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

@objc class  MainPresenterDataStore: NSObject {
    let type: DataStoreType
    let nowPlaying: [MovieModelProtocol]
    let topRated: [MovieModelProtocol]
    let popular: [MovieModelProtocol]
    var latest: MovieModelProtocol?
    var upcoming: [MovieModelProtocol]?
    
    enum DataStoreType {
        case film
        case tvShow
    }
    init(
        type: DataStoreType, nowPlaying: [MovieModelProtocol],
        topRated: [MovieModelProtocol], popular: [MovieModelProtocol],
        latest: MovieModelProtocol? = nil, upcoming: [MovieModelProtocol]? = nil) {
            self.type = type
            self.nowPlaying = nowPlaying
            self.topRated = topRated
            self.popular = popular
            self.latest = latest
            self.upcoming = upcoming
    }
}

final class MainPresenter: MainViewControllerOutputProtocol {
    
    unowned let view: MainViewControllerInputProtocol
    private var dataStore: MainPresenterDataStore?
    var sections: [MovieSectionViewModel] = []
    var interactor: MainInteractorInputProtocol!
    
    init(view: MainViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObjects()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        let movie = sections[indexPath.section].items[indexPath.item]
        Router.showDetail(from: view, for: movie.movieType, and: movie.movieId)
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
 
    func objectsDidReceive(with dataStore: [MainPresenterDataStore]) {
        
        let filmDataStore = dataStore.filter {$0.type == .film}[0]
        let tvShowDataStore = dataStore.filter {$0.type == .tvShow}[0]
        
        sections = [
            MovieSectionViewModel(type: .nowPlaying, items: filmDataStore.nowPlaying + tvShowDataStore.nowPlaying),
            MovieSectionViewModel(type: .topRatedFilms, items: filmDataStore.topRated),
            MovieSectionViewModel(type: .popularFilms, items: filmDataStore.popular),
            MovieSectionViewModel(type: .topRatedTV, items: tvShowDataStore.topRated),
            MovieSectionViewModel(type: .popularTV, items: tvShowDataStore.popular)
        ]
        self.view.reloadData(for: sections)
        
    }
    
    
}

// MARK: - MainViewControllerOutputProtocol Extension

extension MainViewControllerOutputProtocol {
    func didTapCell(at indexPath: IndexPath) {
        let movie = sections[indexPath.section].items[indexPath.item]
        Router.showDetail(from: view, for: movie.movieType, and: movie.movieId)
    }
}
