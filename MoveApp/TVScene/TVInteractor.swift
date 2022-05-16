//
//  TVInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 16.05.2022.
//

import Foundation

protocol TVInteractorInputProtocol {
    init(presenter: TVInteractorOutputProtocol, networkManager: NetworkManagerProtocol)
    func fetchObjects()
}

protocol TVInteractorOutputProtocol: AnyObject {
    func objectsDidReceive(with dataStore: TVPresenterDataStore)
}

final class TVInteractor: TVInteractorInputProtocol {
    
    private unowned let presenter: TVInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(presenter: TVInteractorOutputProtocol, networkManager: NetworkManagerProtocol) {
        self.presenter = presenter
        self.networkManager = networkManager
    }
    
    func fetchObjects() {
        Task {
            guard let latest = try? await networkManager.fetchMovie(for: .latestTv) as? Tv else {print("10,11,12"); return }
            guard let onAir = try? await networkManager.fetchMovie(for: .tvList(type: .onAir)) as? MovieResponse<Tv> else {  return }
            guard let airingToday = try? await networkManager.fetchMovie(for: .tvList(type: .airingToday)) as? MovieResponse<Tv> else { return }
            guard let popular = try? await networkManager.fetchMovie(for: .tvList(type: .popular)) as? MovieResponse<Tv> else { return }
            guard let topRated = try? await networkManager.fetchMovie(for: .tvList(type: .topRated)) as? MovieResponse<Tv> else { return }
            
            let dataStore = TVPresenterDataStore(
                latest: latest,
                onAir: onAir.results,
                airingToday: airingToday.results,
                popular: popular.results,
                topRated: topRated.results
            )
            print("789")
            presenter.objectsDidReceive(with: dataStore)
        }
    }
    
}
