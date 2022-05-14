//
//  MainMovieSectionViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

protocol MainMovieSectionViewModelProtocol {
    var type: MainMovieSectionType { get }
    var items: [MovieCellViewModel] { get }
    init(type: MainMovieSectionType, items: [MovieModelProtocol])
}

enum MainMovieSectionType: String {
    case nowPlaying = "Now Playing"
    case topRatedFilms = "Top rated films"
    case popularFilms = "Popular films"
    case topRatedTv = "Top rated TV shows"
    case popularTv = "Popular TV shows"
}

struct MainMovieSectionViewModel: MainMovieSectionViewModelProtocol, Hashable {
    
    var type: MainMovieSectionType
    var items: [MovieCellViewModel]
    
    private let uuid = UUID()
    
    init(type: MainMovieSectionType, items: [MovieModelProtocol]) {
        self.type = type
        self.items = []
        items.forEach {
            let viewModel = MovieCellViewModel(movie: $0)
            self.items.append(viewModel)
        }
    }
    
    static func == (lhs: MainMovieSectionViewModel, rhs: MainMovieSectionViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
