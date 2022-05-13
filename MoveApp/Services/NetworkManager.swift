//
//  NetworkManager.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchMovie(for type: NetworkRequestType) async throws -> Any
    
}

enum NetworkRequestType {
    case movieList(type: MovieListType)
    case tvList(type: TvListType)
    case movieSearch(query: String)
    case tvSearch(query: String)
    case single(id: Int)
}
enum MovieListType: String {
    case filmsNowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
}
enum TvListType: String {
    case onAir = "on_the_air"
    case popular
    case topRated = "top_rated"
}

enum NetworkError: Error, CustomNSError {
    case apiError
    case invalidURL
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Failed to fetch data"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data"
        case .serializationError:
            return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

class NetworkManager: NetworkManagerProtocol {
    
    
    static let shared: NetworkManagerProtocol = NetworkManager()
    private let apiKey = "7764ef393c7ca0012a42f23871539e91"
    private init () {}
    
    func fetchMovie(for type: NetworkRequestType) async throws -> Any {
        let url = try await getURL(for: type)
        let data = try await loadData(from: url)
        
        switch type {
        case .movieList, .movieSearch, .tvList, .tvSearch:
            return try await decodeJSON(from: data, in: MovieResponse.self)
        case .single:
            return try await decodeJSON(from: data, in: Film.self)
        }
    }
    
    private func loadData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        return data
    }
    
    private func decodeJSON<T: Decodable>(from data: Data?, in type: T.Type) async throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data else { throw NetworkError.noData }
        guard let result = try? decoder.decode(type, from: data) else { throw NetworkError.serializationError }
        return result
    }
    
    private func getURL(for type: NetworkRequestType) async throws -> URL {
        var components = URLComponents()
        let params = try await prepareParameters(for: type)
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        switch type {
        case .movieList(let type):
            components.path = "/3/movie/\(type.rawValue)"
        case .movieSearch:
            components.path = "/3/search/movie"
        case .tvList(let type):
            components.path = "/3/tv/\(type.rawValue)"
        case .tvSearch:
            components.path = "/3/search/tv"
        case .single(let id):
            components.path = "/3/movie/\(id)"
        }
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else { throw NetworkError.invalidURL }
        return url
    }
    
    
    private func prepareParameters(for type: NetworkRequestType) async throws -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["api_key"] = apiKey
        parameters["include_adult"] = "true"
        parameters["region"] = "RU"
        if let systemLanguage = NSLocale.preferredLanguages.first {
            parameters["language"] = String(systemLanguage.prefix(2))
        }
        switch type {
        case .movieList:
            break
        case .movieSearch(let query), .tvSearch(let query):
            parameters["query"] = query
        case .single:
            break
        case .tvList:
            break
        }
        return parameters
    }
}
