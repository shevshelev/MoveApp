//
//  DetilPresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 18.05.2022.
//

import Foundation

struct DetailPresenterDataStore {
    let film: FilmModelProtocol?
    let show: TvModelProtocol?
    let isFavorite: Bool
    let myRate: Double
    var movieType: MovieType {
        if film != nil {
            return .film
        } else {
            return .tv
        }
    }
}

class DetailPresenter: DetailViewControllerOutputProtocol {
    
    private unowned let view: DetailViewControllerInputProtocol
    private var dataStore: DetailPresenterDataStore?
    var interactor: DetailInteractorInputProtocol!
    private var movie: MovieModelProtocol? {
        guard let dataStore = dataStore else { return nil }
        switch dataStore.movieType {
        case .film:
            return dataStore.film
        case .tv:
            return dataStore.show
        }
    }
    var id: Int {
        movie?.id ?? 0
    }
    private var isRated: Double {
        guard let rate = dataStore?.myRate else { return 0.0 }
        return rate
    }
    
    var titleLogo: String? {
        guard let logos = movie?.images?.logos, !logos.isEmpty else { print("no logo"); return nil }
        guard let currentLanguage = Locale.preferredLanguages.first?.prefix(2) else { return nil }
        let currentLanguageLogos = logos.filter {$0.iso6391 ?? "" == currentLanguage }
        if !currentLanguageLogos.isEmpty {
            return currentLanguageLogos.first?.filePath
        } else {
            return logos.first?.filePath
        }
    }
    var title: String? {
        movie?.title
    }
    var originalTitle: String {
        let releaseYear = movie?.releaseDate?.prefix(4)
        if titleLogo != nil {
            return "\(title ?? "")(\(releaseYear ?? ""))"
        } else if title == movie?.originalTitle {
            return "(\(releaseYear ?? ""))"
        } else {
            return "\(movie?.originalTitle ?? "")(\(releaseYear ?? ""))"
        }
    }
    var tagline: String? {
        movie?.tagline
    }
    var voteAverage: Double? {
        movie?.voteAverage
    }
    var description: String {
        """
        ●\(movie?.genres?.reduce("") { "\($0 ?? "") \($1.name ?? "")" } ?? "")
        ● \((movie?.runtime ?? 0) / 60) h \((movie?.runtime ?? 0) % 60) m
        """
            .replacingOccurrences(of: " и ", with: " ")
            .lowercased()
    }
    var overview: String? {
        movie?.overview
    }
    var images: [ImageCellViewModelProtocol] {
        var images:[ImageCellViewModelProtocol] = []
        if !(movie?.images?.backdrops?.isEmpty ?? false) {
            movie?.images?.backdrops?.forEach { images.append(ImageCellViewModel(image: $0)) }
        } else if !(movie?.images?.posters?.isEmpty ?? false) {
            movie?.images?.posters?.forEach { images.append(ImageCellViewModel(image: $0)) }
        } else {
            images.append(ImageCellViewModel(endPoint: movie?.posterPath))
        }
        return images
    }
    var cast: [CreditCellViewModelProtocol] {
        var cast:[CreditCellViewModelProtocol] = []
        movie?.credits?.cast?.forEach {cast.append(CreditCellViewModel(staff: $0)) }
        return cast
    }
    var crew: [String?] {
        var crew:[String?] = []
        movie?.credits?.crew?.forEach { crew.append(String($0.id ?? 0)) }
        return crew
    }
    var budget: Int? {
        guard let budget = dataStore?.film?.budget else { return nil }
        return budget
    }
    var revenue: Int? {
        guard let revenue = dataStore?.film?.revenue else { return nil }
        return revenue
    }
    var status: String? {
        guard let status = dataStore?.show?.status else { return nil }
        return status
    }
    var seasons: [SeasonCellViewModelProtocol]? {
        if dataStore?.movieType == .tv {
            var seasons: [SeasonCellViewModelProtocol] = []
            dataStore?.show?.seasons?.forEach { seasons.append(SeasonCellViewModel(season: $0))}
            return seasons
        } else {
            return nil
        }
    }
    var episodes: [EpisodeCellViewModelProtocol] = []
    
    
    required init(view: DetailViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObject()
    }
    
    func didTapFavouriteButton() {
        interactor.toggleFavoriteStatus()
    }
    func setRate(with rate: Double) {
        interactor.setRate(with: rate)
    }
    func didTapSeasonCell(at indexPath: IndexPath) {
        let season = seasons?[indexPath.item]
        interactor.fetchEpisodes(at: id, in: season?.seasonNumber ?? 0)
    }
    func checkRate() -> Double {
        interactor.rate()
    }
    func deleteRate() {
        interactor.deleteRate()
        view.setRateButtonTitle(with: 0)
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func objectDidReceive(with dataStore: DetailPresenterDataStore) {
        self.dataStore = dataStore
        DispatchQueue.main.async {
            self.view.reloadData()
            self.view.setFavouriteButtonTitle(with: dataStore.isFavorite)
            self.view.setRateButtonTitle(with: dataStore.myRate)
        }
    }
    func episodesDidReceive(with episode: [Episode]) {
        self.episodes = []
        episode.forEach { self.episodes.append(EpisodeCellViewModel(episode: $0))}
        DispatchQueue.main.async {
            self.view.reloadEpisodes()
        }
    }
    func receiveFavouriteStatus(with status: Bool) {
        view.setFavouriteButtonTitle(with: status)
    }
    func receiveRate(with rate: Double) {
        view.setRateButtonTitle(with: rate)
    }
}
