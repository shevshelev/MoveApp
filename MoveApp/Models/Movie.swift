//
//  Movie.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

enum MovieType: String {
    case film = "movie"
    case tv
}

protocol MovieModelProtocol {
    var dataType: MovieType { get }
    var id: Int? { get }
    var title: String { get }
    var tagline: String? { get }
    var originalTitle: String? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
    var originalLanguage: String? { get }
    var spokenLanguages: [Language]? { get }
    var runtime: Int? { get }
    var genres: [Genre]? { get }
    var voteAverage: Double? { get }
    var backdropPath: String? { get }
    var posterPath: String? { get }
    var videos: Videos? { get }
    var images: Images? { get }
    var credits: Credit? { get }
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
    var genres: [Genre]?
    let genreIds: [Int]?
    let homepage: String?
    let id: Int?
    var originalLanguage: String?
    var overview: String?
    let popularity: Double?
    var posterPath: String?
    let productionCompanies: [Company]?
    let productionCountries: [Country]?
    var spokenLanguages: [Language]?
    let status: String?
    var tagline: String?
    let voteAverage: Double?
    let voiteCount: Int?
    var videos: Videos?
    var images: Images?
    var credits: Credit?
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

struct Videos: Decodable {
    let results: [Video]?
}

struct Video: Decodable {
    let iso6391: String?
    let iso31661: String?
    let name: String?
    let key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt: String?
    let id: String?
}

struct Images: Decodable {
    let backdrops: [Image]?
    let logos: [Image]?
    let posters: [Image]?
}

protocol ImageProtocol {
    var filePath: String? { get }
}

struct Image: ImageProtocol, Decodable {
    let aspectRatio: Double?
    let height: Int?
    let iso6391: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount: Double?
    let width: Int?
}

struct Credit: Decodable {
    let cast: [Staff]?
    let crew: [Staff]?
}

struct Staff: Decodable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knowForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?
    let department: String?
    let job: String?
}
