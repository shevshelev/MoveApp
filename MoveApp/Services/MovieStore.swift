//
//  MovieStore.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

//import Foundation
//
//class MovieStore: NetworkManagerProtocol {
//    
//    static let shared = MovieStore()
//    private init() {}
//    
//    private let apiKey = "7764ef393c7ca0012a42f23871539e91"
//    private let baseAPIURL = "https://api.themoviedb.org/3"
//    private let urlSession = URLSession.shared
//    private let jsonDecoder = Utils.jsonDecoder
//    
//    
//    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponce, MovieError>) -> ()) {
//        guard let url = URL(string: "\(baseAPIURL)/move/\(endpoint.rawValue)") else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//        self.loadURLAndDecode(url: url, completion: completion)
//    }
//    
//    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
//        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//        self.loadURLAndDecode(url: url, params: ["append_to_response":"videos, credits"], completion: completion)
//    }
//    
//    func searchMovie(query: String, completion: @escaping (Result<MovieResponce, MovieError>) -> ()) {
//        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//        self.loadURLAndDecode(
//            url: url,
//            params: [
//                "language":"ru-RU",
//                "include_adult": "true",
//                "region": "RU",
//                "query": query
//                
//                ]
//            , completion: completion
//        )
//    }
//    
//    private func loadURLAndDecode<T: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping(Result<T, MovieError>) -> ()) {
//        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
//        
//        if let params = params {
//            queryItems.append(contentsOf: params.map {URLQueryItem(name: $0.key, value: $0.value)})
//        }
//        urlComponents.queryItems = queryItems
//        guard let finalURL = urlComponents.url else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//        
//        urlSession.dataTask(with: finalURL) {[unowned self] data, response, error in
//            if error != nil {
//                self.executeCompletionHandlerMainThread(with: .failure(.apiError), comopletion: completion)
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
//                self.executeCompletionHandlerMainThread(with: .failure(.invalidResponse), comopletion: completion)
//                return
//            }
//            guard let data = data else {
//                self.executeCompletionHandlerMainThread(with: .failure(.noData), comopletion: completion)
//                return
//            }
//            
//            do {
//                let decoderResponse = try self.jsonDecoder.decode(T.self, from: data)
//                self.executeCompletionHandlerMainThread(with: .success(decoderResponse), comopletion: completion)
//            } catch {
//                self.executeCompletionHandlerMainThread(with: .failure(.serializationError), comopletion: completion)
//            }
//        }.resume()
//    }
//    
//    private func executeCompletionHandlerMainThread<T: Decodable>(with result: Result<T, MovieError>, comopletion: @escaping (Result<T, MovieError>) -> ()) {
//        DispatchQueue.main.async {
//            comopletion(result)
//        }
//    }
//    
//}
