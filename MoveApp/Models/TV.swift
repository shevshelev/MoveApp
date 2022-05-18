//
//  TV.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

class Tv: Movie, MovieModelProtocol {
    var dataType: MovieType = .tv
    var createdBy: [Staff]?
    var episodeRunTime: [Int]?
    var firstAirDate: String?
    var inProduction: Bool?
    var languages: [String]?
    var lastAirDate: String?
    var lastEpisodeToAir: Episode?
    var nextEpisodeToAir: Episode?
    var networks: [Company]?
    var numberOfEpisodes: Int?
    var numberOfSeasons: Int?
    var originCountry: [String]?
    var seasons: [Season]?
    var type: String?
    var title: String?
    var originalTitle: String?
    
    private enum CodingKeys: String, CodingKey {
        
        case createdBy
        case episodeRunTime
        case firstAirDate
        case inProduction
        case languages
        case lastAirDate
        case lastEpisodeToAir
        case nextEpisodeToAir
        case networks
        case numberOfEpisodes
        case numberOfSeasons
        case originCountry
        case seasons
        case type
        case originalTitle = "original_name"
        case title = "name"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdBy = try container.decodeIfPresent([Staff].self, forKey: .createdBy)
        episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime)
        firstAirDate = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        inProduction = try container.decodeIfPresent(Bool.self, forKey: .inProduction)
        languages = try container.decodeIfPresent([String].self, forKey: .languages)
        lastAirDate = try container.decodeIfPresent(String.self, forKey: .lastAirDate)
        lastEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .lastEpisodeToAir)
        nextEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .nextEpisodeToAir)
        networks = try container.decodeIfPresent([Company].self, forKey: .networks)
        numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons)
        originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }
}

struct Episode: Decodable {
    let airDate: String?
    let episodeNumber: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let productionCode: String?
    let seasonNumber: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?
}

struct Season: Decodable {
    let airDate: String?
    let episodeCount: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?
}
