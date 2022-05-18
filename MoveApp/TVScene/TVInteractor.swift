//
//  TVInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 16.05.2022.
//

import Foundation

final class TVInteractor: MainInteractorInputProtocol {
    
    private unowned let presenter: MainInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(presenter: MainInteractorOutputProtocol, networkManager: NetworkManagerProtocol) {
        self.presenter = presenter
        self.networkManager = networkManager
    }
    
    func fetchObjects() {
        Task {
            guard let latest = try? await networkManager.fetchMovie(for: .latestTv) as? Tv else { return }
            guard let onAir = try? await networkManager.fetchMovie(for: .tvList(type: .onAir)) as? MovieResponse<Tv> else {  return }
            guard let airingToday = try? await networkManager.fetchMovie(for: .tvList(type: .airingToday)) as? MovieResponse<Tv> else { return }
            guard let popular = try? await networkManager.fetchMovie(for: .tvList(type: .popular)) as? MovieResponse<Tv> else { return }
            guard let topRated = try? await networkManager.fetchMovie(for: .tvList(type: .topRated)) as? MovieResponse<Tv> else { return }
            
            let dataStore = MainPresenterDataStore(
                type: .tvShow,
                nowPlaying: onAir.results,
                topRated: topRated.results,
                popular: popular.results,
                latest: latest,
                upcoming: airingToday.results
            )
            presenter.objectsDidReceive!(with: dataStore)
        }
    }
}
