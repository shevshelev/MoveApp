//
//  Movie.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import Foundation

class Film: Movie, MovieProtocol {
    let adult: Bool? = nil
    let belongsToCollection: MovieCollection? = nil
    let budget: Int = 0
    let imdbId: String = ""
    var originalTitle: String = ""
    let releaseDate: String = ""
    let revenue: Int = 0
    let runtime: Int = 0
    var title: String = ""
    let video: Bool? = nil
    let videos: [String: Video] = [:]
    let credits: Credit? = nil
}

struct Video: Decodable, Hashable {
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

struct Credit: Decodable, Hashable {
    let cast: Staff?
    let crew: Staff?
}

struct Staff: Decodable, Hashable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knowForDepartment: String
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
