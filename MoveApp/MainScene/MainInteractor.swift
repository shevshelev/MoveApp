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
            guard let nowPlayingFilms = try? await networkManager.fetchMovie(for:.movieList(type: .nowPlaying)) as? MovieResponse<Film> else { return }
            guard let topRatedFilms = try? await networkManager.fetchMovie(for: .movieList(type: .topRated)) as? MovieResponse<Film> else { return }
            guard let popularFilms = try? await networkManager.fetchMovie(for: .movieList(type: .popular)) as? MovieResponse<Film> else { return }
            guard let nowPlayingTv = try? await networkManager.fetchMovie(for: .tvList(type: .onAir)) as? MovieResponse<Tv> else { return }
            guard let topRatedTv = try? await networkManager.fetchMovie(for: .tvList(type: .topRated)) as? MovieResponse<Tv> else { return }
            guard let popularTv = try? await networkManager.fetchMovie(for: .tvList(type: .popular)) as? MovieResponse<Tv> else { return }
            
            let dataStore = MainPresenterDataStore(
                nowPlaying: (nowPlayingFilms.results + nowPlayingTv.results).shuffled(),
                topRatedFilms:  topRatedFilms.results,
                popularMFilms: popularFilms.results,
                popularTv: popularTv.results,
                topRatedTv: topRatedTv.results
            )
            
            presenter.objectsDidReceive(with: dataStore)
            
        }
    }
}
