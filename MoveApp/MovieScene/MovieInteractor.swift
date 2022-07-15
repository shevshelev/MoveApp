//
//  MovieInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import Foundation

final class MovieInteractor: MainInteractorInputProtocol {
    
    private unowned let presenter: MainInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(presenter: MainInteractorOutputProtocol, networkManager: NetworkManagerProtocol) {
        self.presenter = presenter
        self.networkManager = networkManager
    }
    
    func fetchObjects() {
        Task {
            guard let nowPlaying = try? await networkManager.sendRequest(for:.movieList(type: .nowPlaying)) as? MovieResponse<Film> else { return }
            guard let topRated = try? await networkManager.sendRequest(for: .movieList(type: .topRated)) as? MovieResponse<Film> else { return }
            guard let popular = try? await networkManager.sendRequest(for: .movieList(type: .popular)) as? MovieResponse<Film> else { return }
            guard let upcoming = try? await networkManager.sendRequest(for: .movieList(type: .upcoming)) as? MovieResponse<Film> else { return }
            guard let latest = try? await networkManager.sendRequest(for: .latestMovie) as? Film else { return }
            
            let dataStore = MainPresenterDataStore(
                type: .film,
                nowPlaying: nowPlaying.results,
                topRated: topRated.results,
                popular: popular.results,
                latest: latest,
                upcoming: upcoming.results
            )
            
            presenter.objectsDidReceive!(with: dataStore)
            
        }
    }
    
    
}
