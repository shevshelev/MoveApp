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
    var id: Int? {
        movie?.id
    }
    
    var titleLogo: String? {
        guard let logo = movie?.images?.logos?.first?.filePath else { return nil }
        return logo
    }
    
    var title: String? {
        movie?.title
    }
    var originalTitle: String? {
        movie?.originalTitle
    }
    var tagline: String? {
        movie?.tagline
    }
    
    var voteAverage: Double? {
//        String(format: "%.2f", movie?.voteAverage ?? 0)
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
    var originalLanguage: String? {
        movie?.originalLanguage
    }
    var spokenLanguages: String? {
        movie?.spokenLanguages?.reduce("") { "\( $0 ?? "") \($1.name ?? "")" }
    }
    var posterPath: String? {
        movie?.posterPath
    }
    var images: [ImageCellViewModelProtocol] {
        var images:[ImageCellViewModelProtocol] = []
        movie?.images?.backdrops?.forEach { images.append(ImageCellViewModel(image: $0)) }
        return images
    }
    var cast: [String?] {
        var cast:[String?] = []
        movie?.credits?.cast?.forEach {cast.append(String($0.id ?? 0)) }
        return cast
    }
    var crew: [String?] {
        var crew:[String?] = []
        movie?.credits?.crew?.forEach { crew.append(String($0.id ?? 0)) }
        return crew
    }
    var budget: String? {
        guard let budget = dataStore?.film?.budget else { return nil }
        return String(budget)
    }
    var revenue: String? {
        guard let revenue = dataStore?.film?.revenue else { return nil }
        return String(revenue)
    }
    var status: String? {
        guard let status = dataStore?.show?.status else { return nil }
        return status
    }
    
    
    required init(view: DetailViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchObject()
    }
    
    func didTapFavouriteButton() {
        
    }
    
    
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func objectDidReceive(with dataStore: DetailPresenterDataStore) {
        self.dataStore = dataStore
        DispatchQueue.main.async {
            self.view.reloadData()
        }
    }
}
