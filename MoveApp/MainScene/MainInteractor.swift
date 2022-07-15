//
//  MainInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

protocol MainInteractorInputProtocol {
    init(presenter: MainInteractorOutputProtocol, networkManager: NetworkManagerProtocol)
    func fetchObjects()
}

@objc protocol MainInteractorOutputProtocol: AnyObject {
    @objc optional func objectsDidReceive(with dataStore: [MainPresenterDataStore])
    @objc optional func objectsDidReceive(with dataStore: MainPresenterDataStore)
}

final class MainInteractor: MainInteractorInputProtocol {
    
    private unowned let presenter: MainInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(presenter: MainInteractorOutputProtocol, networkManager: NetworkManagerProtocol) {
        self.presenter = presenter
        self.networkManager = networkManager
    }
    
    func fetchObjects() {
        Task {
            guard let nowPlayingFilms = try? await networkManager.sendRequest(for:.movieList(type: .nowPlaying)) as? MovieResponse<Film> else { return }
            guard let topRatedFilms = try? await networkManager.sendRequest(for: .movieList(type: .topRated)) as? MovieResponse<Film> else { return }
            guard let popularFilms = try? await networkManager.sendRequest(for: .movieList(type: .popular)) as? MovieResponse<Film> else { return }
            guard let nowPlayingTv = try? await networkManager.sendRequest(for: .tvList(type: .onAir)) as? MovieResponse<Tv> else { return }
            guard let topRatedTv = try? await networkManager.sendRequest(for: .tvList(type: .topRated)) as? MovieResponse<Tv> else { return }
            guard let popularTv = try? await networkManager.sendRequest(for: .tvList(type: .popular)) as? MovieResponse<Tv> else { return }
            
            let filmsDataStore = MainPresenterDataStore(
                type: .film,
                nowPlaying: nowPlayingFilms.results,
                topRated: topRatedFilms.results,
                popular: popularFilms.results
            )
            let tvDataStore = MainPresenterDataStore(
                type: .tvShow,
                nowPlaying: nowPlayingTv.results,
                topRated: topRatedTv.results,
                popular: popularTv.results
            )
            DispatchQueue.main.async {
                self.presenter.objectsDidReceive!(with: [filmsDataStore, tvDataStore])
            }
            
        }
    }
}
