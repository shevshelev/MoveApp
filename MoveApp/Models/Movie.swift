//
//  Movie.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

protocol MovieModelProtocol {
    var title: String? { get }
    var originalTitle: String? { get }
    var backdropPath: String? { get }
    var posterPath: String? { get }
}

struct MovieResponse<T: MovieModelProtocol & Decodable>: Decodable {
    let page: Int?
    let results: [T]
    let dates: [String: String]?
    let totalPages: Int?
    let totalResults: Int?
}

class Movie: Decodable {
    var backdropPath: String?
    let genres: [Genre]?
    let genreIds: [Int]?
    let homepage: String?
    let id: Int
    let originalLanguage: String
    let overview: String
    let popularity: Double
    var posterPath: String?
    let productionCompanies: [Company]?
    let productionCountries: [Country]?
    let spokenLanguages: [Language]?
    let status: String?
    let tagline: String?
    let voteAverage: Double
    let voiteCount: Int?
}

struct MovieCollection: Decodable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}

struct Genre: Decodable {
    let id: Int?
    let name: String?
}

struct Company: Decodable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
}

struct Country: Decodable {
    let iso31661: String?
    let name: String?
}

struct Language: Decodable {
    let englishName: String?
    let iso6391: String?
    let name: String?
}
