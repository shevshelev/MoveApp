//
//  FavouritesInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 07.06.2022.
//

import Foundation

protocol FavouritesInteractorInputProtocol {
    init(presenter: FavouritesInteractorOutputProtocol, networkManager: NetworkManagerProtocol)
    func fetchObjects()
}
protocol FavouritesInteractorOutputProtocol: AnyObject {
    func objectsDidReceive(with dataStore: FavouritesPresenterDataStore)
}

class FavouritesInteractor: FavouritesInteractorInputProtocol {
    
    private unowned let presenter: FavouritesInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    
    required init(presenter: FavouritesInteractorOutputProtocol, networkManager: NetworkManagerProtocol) {
        self.presenter = presenter
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        self.networkManager = NetworkManager.shared
        //+++++++++++++++++++++++++++++
    }
    
    func fetchObjects() {
        Task {
            guard let favouritesFilms = try? await networkManager.sendRequest(for: .favourites(type: .film)) as? MovieResponse<Film> else { return }
            guard let favouritesShows = try? await networkManager.sendRequest(for: .favourites(type: .tv)) as? MovieResponse<Tv> else { return }
            let dataStore = FavouritesPresenterDataStore(
                tvShows: favouritesShows.results,
                films: favouritesFilms.results
            )
            DispatchQueue.main.async {
                self.presenter.objectsDidReceive(with: dataStore)
            }
        }
    }
}
