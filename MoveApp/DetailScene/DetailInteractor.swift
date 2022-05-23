//
//  DetailInteractor.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 18.05.2022.
//

import Foundation

protocol DetailInteractorInputProtocol {
    init(id: Int?,
         movieType: MovieType,
        presenter: DetailInteractorOutputProtocol,
        networkManager: NetworkManagerProtocol
    )
    func fetchObject()
    func fetchEpisodes(at tvId: Int, in seasonNumber: Int)
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func objectDidReceive(with dataStore: DetailPresenterDataStore)
    func episodesDidReceive(with episode: [Episode])
}

class DetailInteractor: DetailInteractorInputProtocol {
    
    private unowned let presenter: DetailInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    private let movieId: Int?
    private let movieType: MovieType
    
    required init(
        id: Int?,
        movieType: MovieType,
        presenter: DetailInteractorOutputProtocol,
        networkManager: NetworkManagerProtocol
    ) {
        self.presenter = presenter
        self.networkManager = networkManager
        self.movieId = id
        self.movieType = movieType
    }
    
    func fetchObject() {
        Task {
            let dataStore: DetailPresenterDataStore
            switch movieType {
            case .film:
                guard let movie = try await networkManager.fetchMovie(for: .single(type: movieType, id: movieId ?? 0)) as? Film else { return }
                dataStore = DetailPresenterDataStore(film: movie, show: nil)
            case .tv:
                guard let movie = try await networkManager.fetchMovie(for: .single(type: movieType, id: movieId ?? 0)) as? Tv else { return }
                dataStore = DetailPresenterDataStore(film: nil, show: movie)
            }
            presenter.objectDidReceive(with: dataStore)
        }
    }
    func fetchEpisodes(at tvId: Int, in seasonNumber: Int) {
        Task {
            guard let season = try await networkManager.fetchMovie(for: .tvSeason(tvId: tvId, seasonNumber: seasonNumber)) as? Season else { return }
            guard let episode = season.episodes else { return }
            presenter.episodesDidReceive(with: episode)
        }
    }
    
}
