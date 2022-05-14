//
//  Movie.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

protocol MovieProtocol: Decodable, Hashable {
    var title: String { get }
    var originalTitle: String { get }
}

struct MovieResponse: Decodable {
    let page: Int?
    let results: [Movie]
    let dates: [String: String]?
    let totalPages: Int?
    let totalResults: Int?
}

class Movie: Decodable, Hashable {
    var uuid: UUID? = UUID()
    let backdropPath: String?
    let genres: [Genre]?
    let genreIds: [Int]?
    let homepage: String?
    let id: Int
    let originalLanguage: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [Company]?
    let productionCountries: [Country]?
    let spokenLanguages: [Language]?
    let status: String?
    let tagline: String?
    let voteAverage: Double
    let voiteCount: Int?
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.uuid == lhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct MovieCollection: Decodable, Hashable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}

struct Genre: Decodable, Hashable {
    let id: Int?
    let name: String?
}

struct Company: Decodable, Hashable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
}

struct Country: Decodable, Hashable {
    let iso31661: String?
    let name: String?
}

struct Language: Decodable, Hashable {
    let englishName: String?
    let iso6391: String?
    let name: String?
}
