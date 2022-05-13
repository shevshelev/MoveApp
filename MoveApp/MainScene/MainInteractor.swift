//
//  MainInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

protocol MainInteractorInputProtocol {
    init(presenter: MainInteractorOutputProtocol)
    func fetchObjects()
}

protocol MainInteractorOutputProtocol: AnyObject {
    func objectsDidReceive(with dataStore: MainPresenterDataStore)
}

final class MainInteractor: MainInteractorInputProtocol {
    
    private unowned let presenter: MainInteractorOutputProtocol!
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    
    init(presenter: MainInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func fetchObjects() {
        Task {
            guard let nowPlayingFilms = try? await networkManager.fetchMovie(for:.movieList(type: .filmsNowPlaying)) as? MovieResponse else { return }
            guard let topRatedFilms = try? await networkManager.fetchMovie(for: .movieList(type: .topRated)) as? MovieResponse else { return }
            guard let popularFilms = try? await networkManager.fetchMovie(for: .movieList(type: .popular)) as? MovieResponse else { return }
            guard let nowPlayingTv = try? await networkManager.fetchMovie(for: .tvList(type: .onAir)) as? MovieResponse else { return }
            guard let topRatedTv = try? await networkManager.fetchMovie(for: .tvList(type: .topRated)) as? MovieResponse else { return }
            guard let popularTv = try? await networkManager.fetchMovie(for: .tvList(type: .popular)) as? MovieResponse else { return }
            
            let dataStore = MainPresenterDataStore(
                nowPlaying: topRatedFilms.results,
                topRatedFilms: popularFilms.results,
                popularMFilms: topRatedTv.results,
                popularTv: popularTv.results,
                topRatedTv: (nowPlayingFilms.results + nowPlayingTv.results).shuffled()
            )
            
            presenter.objectsDidReceive(with: dataStore)
            
        }
    }
}
