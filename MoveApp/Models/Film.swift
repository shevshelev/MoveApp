//
//  Movie.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import Foundation

protocol FilmModelProtocol: MovieModelProtocol {
    var budget: Int? { get }
    var revenue: Int? { get }
}

class Film: Movie, FilmModelProtocol {
    var dataType: MovieType = .film
    var adult: Bool?
    var belongsToCollection: MovieCollection?
    var budget: Int?
    var imdbId: String?
    var originalTitle: String?
    var releaseDate: String?
    var revenue: Int?
    var runtime: Int?
    var title: String
    var video: Bool?

    
    private enum CodingKeys: String, CodingKey {
        case adult
        case belongsToCollection
        case budget
        case imdbId
        case originalTitle
        case releaseDate
        case revenue
        case runtime
        case title
        case video
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        belongsToCollection = try container.decodeIfPresent(MovieCollection.self, forKey: .belongsToCollection)
        budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        title = try container.decode(String.self, forKey: .title)
        video = try container.decodeIfPresent(Bool.self, forKey: .video)
        try super.init(from: decoder)
    }
}
