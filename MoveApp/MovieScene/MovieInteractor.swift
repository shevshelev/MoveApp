//
//  MovieInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import Foundation

protocol MovieInteractorInputProtocol {
    init(presenter: MovieInteractorOutputProtocol, networkManager: NetworkManagerProtocol)
    func fetchObjects()
}

protocol MovieInteractorOutputProtocol: AnyObject {
    func objectsDidReceive(with dataStore: MoviePresenterDataStore)
}

final class MovieInteractor: MovieInteractorInputProtocol {
    
    private unowned let presenter: MovieInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(presenter: MovieInteractorOutputProtocol, networkManager: NetworkManagerProtocol) {
        self.presenter = presenter
        self.networkManager = networkManager
    }
    
    func fetchObjects() {
        Task {
            guard let nowPlaying = try? await networkManager.fetchMovie(for:.movieList(type: .nowPlaying)) as? MovieResponse<Film> else { return }
            guard let topRated = try? await networkManager.fetchMovie(for: .movieList(type: .topRated)) as? MovieResponse<Film> else { return }
            guard let popular = try? await networkManager.fetchMovie(for: .movieList(type: .popular)) as? MovieResponse<Film> else { return }
            guard let upcoming = try? await networkManager.fetchMovie(for: .movieList(type: .upcoming)) as? MovieResponse<Film> else { return }
            guard let latest = try? await networkManager.fetchMovie(for: .latestMovie) as? Film else { return }
            
            let dataStore = MoviePresenterDataStore(
                latest: latest,
                nowPlaying: nowPlaying.results,
                popular: popular.results,
                topRated: topRated.results,
                upcoming: upcoming.results
            )
            
            presenter.objectsDidReceive(with: dataStore)
            
        }
    }
    
    
}
