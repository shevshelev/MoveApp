//
//  UImageView+Additions.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import UIKit

extension UIImageView {
    
    func fetchImage(with endpoint: String) async throws {
        guard let url = getImageURL(with: endpoint) else { print("hernya"); return }
        if let cachedImage = getCachedImage(from: url) {
            DispatchQueue.main.async {
                self.image = cachedImage
                print("cache")
            }
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        saveDataToCache(with: data, and: response)
        guard let image = UIImage(data: data) else { throw NetworkError.noData }
        DispatchQueue.main.async {
            self.image = image
            print("main")
        }
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        guard let cachedResponse = URLCache.shared.cachedResponse(for: request) else { return nil }
        guard url.lastPathComponent == cachedResponse.response.url?.lastPathComponent else { return nil }
        return UIImage(data: cachedResponse.data)
    }
        
    private func getImageURL(with endpoint: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/w500\(endpoint)"
        print("\(components.url)")
        return components.url
    }
}
