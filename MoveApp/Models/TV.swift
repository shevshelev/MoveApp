//
//  TV.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import Foundation

class Tv: Movie, MovieProtocol {
    
    let createdBy: [Staff] = []
    let episodeRunTime: [Int] = []
    let firstAirDate: String = ""
    let inProduction: Bool? = nil
    let languages: [String] = []
    let lastAirDate: String = ""
    let lastEpisodeToAir: Episode? = nil
    let name: String = ""
    let nextEpisodeToAir: String = ""
    let networks: [Company] = []
    let numberOfEpisodes: Int = 0
    let numberOfSeasons: Int = 0
    let originCountry: [String] = []
    let originalName: String = ""
    let seasons: [Season] = []
    let type: String = ""
    
    var title: String {
        name
    }
    var originalTitle: String {
        originalName
    }
}

struct Episode: Decodable, Hashable {
    let airDate: String
    let episodeNumber: Int
    let id: Int
    let name: String
    let overview: String
    let productionCode: String
    let seasonNumber: Int
    let stillPath: String?
    let voteAverage: Double
    let voteCount: Int
}

struct Season: Decodable, Hashable {
    let airDate: String
    let episodeCount: Int
    let id: Int
    let name: String
    let overview: String
    let posterPath: String
    let seasonNumber: Int
}
