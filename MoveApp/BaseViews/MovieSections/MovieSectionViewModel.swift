//
//  MovieSectionViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import Foundation

enum MovieSectionType: String {
    case nowPlaying = "Now Playing"
    case topRatedFilms = "Top rated Films"
    case popularFilms = "Popular Films"
    case popularTV = "Popular TV shows"
    case topRatedTV = "Top rated TV shows"
    case topRated = "Top rated"
    case popular = "Popular"
    case latest = "Latest"
    case upcoming = "Upcoming"
    case airingToday = "Airing today"
}

struct MovieSectionViewModel: MovieSectionViewModelProtocol, Hashable {
    
    var type: MovieSectionType
    var items: [MovieCellViewModel]
    
    private let uuid = UUID()
    
    init(type: MovieSectionType, items: [MovieModelProtocol]) {
        self.type = type
        self.items = []
        items.forEach {
            let viewModel = MovieCellViewModel(movie: $0)
            self.items.append(viewModel)
        }
    }
    
    init(type: MovieSectionType, item: MovieModelProtocol) {
        self.type = type
        items = [MovieCellViewModel(movie: item)]
    }
    
    static func == (lhs: MovieSectionViewModel, rhs: MovieSectionViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

