//
//  TV.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

protocol TvModelProtocol: MovieModelProtocol {
    var status: String? { get }
    var seasons: [Season]? { get }
}

class Tv: Movie, TvModelProtocol {
    var dataType: MovieType = .tv
    var createdBy: [Staff]?
    var episodeRunTime: [Int]?
    var releaseDate: String?
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
    var title: String
    var originalTitle: String?
    
    var runtime: Int? {
        if let episodeRunTime = episodeRunTime, !episodeRunTime.isEmpty {
            var sum = 0
            episodeRunTime.forEach { sum += $0 }
            return sum / episodeRunTime.count
        } else {
            return nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case createdBy
        case episodeRunTime
        case releaseDate = "firstAirDate"
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
        case originalTitle = "originalName"
        case title = "name"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        createdBy = try container.decodeIfPresent([Staff].self, forKey: .createdBy)
        episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime)
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
        try super.init(from: decoder)
    }
}

struct Season: Decodable {
    let airDate: String?
    let episodes: [Episode]?
    let episodeCount: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?
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
