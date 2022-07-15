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
    func toggleFavoriteStatus()
    func setRate(with rate: Double)
    func rate() -> Double
    func deleteRate()
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func objectDidReceive(with dataStore: DetailPresenterDataStore)
    func episodesDidReceive(with episode: [Episode])
    func receiveFavouriteStatus(with status: Bool)
    func receiveRate(with rate: Double)
}

class DetailInteractor: DetailInteractorInputProtocol {
    private unowned let presenter: DetailInteractorOutputProtocol
    private let networkManager: NetworkManagerProtocol
    private let dataManager: DataManagerProtocol = DataManager.shared
    private let movieId: Int?
    private let movieType: MovieType
    
    private var isFavourite: Bool {
        get {
            dataManager.getFavouriteStatus(for: movieType, movieId ?? 0)
        } set {
            dataManager.setFavouriteStatus(for: movieType, movieId ?? 0, with: newValue)
            presenter.receiveFavouriteStatus(with: newValue)
        }
    }
    private var myRate: Double {
        get {
            dataManager.getRate(for: movieType, movieId ?? 0)
        } set {
            dataManager.setRate(for: movieType, movieId ?? 0, with: newValue)
            presenter.receiveRate(with: newValue)
        }
    }
    
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
    
    func toggleFavoriteStatus() {
        Task {
            isFavourite.toggle()
            let _ = try await networkManager.sendRequest(for: .setFavouriteStatus(type: movieType, id: movieId ?? 0, status: isFavourite))
            print(isFavourite)
        }
    }
    func setRate(with rate: Double) {
        Task {
            myRate = rate
            let _ = try await networkManager.sendRequest(for: .setRate(type: movieType, id: movieId ?? 0, rate: rate))
        }
    }
    
    func rate() -> Double {
        myRate
    }
    func deleteRate() {
        Task {
            myRate = 0
            let _ = try await networkManager.sendRequest(for: .deleteRate(type: movieType, id: movieId ?? 0))
        }
    }
    
    func fetchObject() {
        Task {
            let dataStore: DetailPresenterDataStore
            switch movieType {
            case .film:
                guard let movie = try await networkManager.sendRequest(for: .single(type: movieType, id: movieId ?? 0)) as? Film else { return }
                dataStore = DetailPresenterDataStore(
                    film: movie,
                    show: nil,
                    isFavorite: isFavourite,
                    myRate: myRate
                )
            case .tv:
                guard let movie = try await networkManager.sendRequest(for: .single(type: movieType, id: movieId ?? 0)) as? Tv else { return }
                dataStore = DetailPresenterDataStore(
                    film: nil,
                    show: movie,
                    isFavorite: isFavourite,
                    myRate: myRate
                )
            }
            presenter.objectDidReceive(with: dataStore)
        }
    }
    func fetchEpisodes(at tvId: Int, in seasonNumber: Int) {
        Task {
            guard let season = try await networkManager.sendRequest(for: .tvSeason(tvId: tvId, seasonNumber: seasonNumber)) as? Season else { return }
            guard let episode = season.episodes else { return }
            presenter.episodesDidReceive(with: episode)
        }
    }   
}
