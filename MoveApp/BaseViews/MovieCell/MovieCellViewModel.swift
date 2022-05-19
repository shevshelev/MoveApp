//
//  MovieCellViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 14.05.2022.
//

import Foundation

protocol MovieCellViewModelProtocol {
    var movieType: MovieType { get }
    var movieId: Int? { get }
    var title: String { get }
    var posterURL: String? { get }
    var backdropURL: String? { get }
    init(movie: MovieModelProtocol)
}

class MovieCellViewModel: MovieCellViewModelProtocol, Hashable {
    
    private let uuid: UUID
    private let movie: MovieModelProtocol
    
    var movieId: Int? {
        movie.id
    }
    
    var movieType: MovieType {
        movie.dataType
    }
    
    var title: String {
        let title = movie.title
        if let original = movie.originalTitle, original != title {
            return "\(title) (\(original))"
        }
        return "\(title)"
    }
    
    var posterURL: String? {
        movie.posterPath
    }
    
    var backdropURL: String? {
        movie.backdropPath
    }
    
    required init(movie: MovieModelProtocol) {
        self.movie = movie
        uuid = UUID()
    }
    
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
