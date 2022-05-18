//
//  Movie.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import Foundation

class Film: Movie, MovieModelProtocol {
    var dataType: MovieType = .film
    var adult: Bool? = nil
    var belongsToCollection: MovieCollection? = nil
    var budget: Int? = nil
    var imdbId: String? = nil
    var originalTitle: String? = nil
    var releaseDate: String? = nil
    var revenue: Int? = nil
    var runtime: Int? = nil
    var title: String? = nil
    var video: Bool? = nil
    var videos: [String: Video]? = nil
    var credits: Credit? = nil
    
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
        case videos
        case credits
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        belongsToCollection = try container.decodeIfPresent(MovieCollection.self, forKey: .belongsToCollection)
        budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        video = try container.decodeIfPresent(Bool.self, forKey: .video)
    }
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

struct Credit: Decodable {
    let cast: Staff?
    let crew: Staff?
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
