//
//  NetworkManager.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchMovie(for type: NetworkRequestType) async throws -> Any
    func setFavouriteStatus(for type: MovieType, _ id: Int, with status: Bool)
    func setRate(for type: MovieType, _ id: Int, rate: Double)
    func deleteRate(for type: MovieType, _ id: Int)
    
}

enum NetworkRequestType {
    case movieList(type: MovieListType)
    case tvList(type: TvListType)
    case movieSearch(query: String)
    case tvSearch(query: String)
    case single(type: MovieType, id: Int)
    case latestMovie
    case latestTv
    case tvSeason(tvId: Int, seasonNumber: Int)
}
enum MovieListType: String {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
}
enum TvListType: String {
    case onAir = "on_the_air"
    case popular
    case topRated = "top_rated"
    case airingToday = "airing_today"
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
        case .movieList, .movieSearch:
            return try await decodeJSON(from: data, in: MovieResponse<Film>.self)
        case .latestMovie:
            return try await decodeJSON(from: data, in: Film.self)
        case .tvList, .tvSearch:
            return try await decodeJSON(from: data, in: MovieResponse<Tv>.self)
        case .latestTv:
            return try await decodeJSON(from: data, in: Tv.self)
        case .single (let (type, _)):
            switch type {
            case .film:
                return try await decodeJSON(from: data, in: Film.self)
            case .tv:
                return try await decodeJSON(from: data, in: Tv.self)
            }
        case .tvSeason:
            return try await decodeJSON(from: data, in: Season.self)
        }
    }
    
    
    
    
    func setFavouriteStatus(for type: MovieType, _ id: Int, with status: Bool) {
        guard let url = URL(string: "https://api.themoviedb.org/3/account/12385898/favorite?api_key=7764ef393c7ca0012a42f23871539e91&session_id=aac8525364566796e72c6c5e7d5021d18c88336e") else { return }
        var request = URLRequest(url: url)
        let body: [String: AnyHashable] = [
            "media_type" : type.rawValue,
            "media_id" : id,
            "favorite" : status
        ]
        request.httpMethod = "POST"
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(response)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func setRate(for type: MovieType, _ id: Int, rate: Double) {
        guard let url = URL(string: "https://api.themoviedb.org/3/\(type.rawValue)/\(id)/rating?api_key=7764ef393c7ca0012a42f23871539e91&session_id=aac8525364566796e72c6c5e7d5021d18c88336e") else { return }
        var request = URLRequest(url: url)
        let body: [String: AnyHashable] = [
            "value" : rate
        ]
        request.httpMethod = "POST"
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(response)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func deleteRate(for type: MovieType, _ id: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/\(type.rawValue)/\(id)/rating?api_key=7764ef393c7ca0012a42f23871539e91&session_id=aac8525364566796e72c6c5e7d5021d18c88336e") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(response)
            } catch {
                print(error)
            }
        }
        task.resume()
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
        case .single(let (type, id)):
            components.path = "/3/\(type.rawValue)/\(id)"
        case .latestMovie:
            components.path = "/3/movie/latest"
        case .latestTv:
            components.path = "/3/tv/latest"
        case .tvSeason(let (tvId, seasonNumber)):
            components.path = "/3/tv/\(tvId)/season/\(seasonNumber)"
        }
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else { throw NetworkError.invalidURL }
        print(url)
        return url
    }
    
    private func prepareParameters(for type: NetworkRequestType) async throws -> [String: String] {
        var parameters: [String: String] = [:]
        let systemLanguage = NSLocale.preferredLanguages.first
        parameters["api_key"] = apiKey
        parameters["include_adult"] = "true"
        parameters["region"] = Locale.current.regionCode
        parameters["language"] = systemLanguage
        switch type {
        case .movieList, .tvList, .latestMovie, .latestTv, .tvSeason:
            break
        case .single:
            parameters["append_to_response"] = "videos,images,credits"
            parameters["include_image_language"] = "\(systemLanguage?.prefix(2) ?? ""),en,null"
        case .movieSearch(let query), .tvSearch(let query):
            parameters["query"] = query
        }
        return parameters
    }
}
