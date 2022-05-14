//
//  UImageView+Additions.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 13.05.2022.
//

import UIKit

extension UIImageView {
    
    func fetchImage(with endpoint: String) async throws {
        let url = try await getImageURL(with: endpoint)
        if let cachedImage = await getCachedImage(from: url) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if url.lastPathComponent == response.url?.lastPathComponent {
        await saveDataToCache(with: data, and: response)
        guard let image = UIImage(data: data) else { throw NetworkError.noData }
        DispatchQueue.main.async {
            self.image = image
        }
        } else {
            DispatchQueue.main.async {
                self.image = nil
            }
        }
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) async {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) async -> UIImage? {
        let request = URLRequest(url: url)
        guard let cachedResponse = URLCache.shared.cachedResponse(for: request) else { return nil }
        guard url.lastPathComponent == cachedResponse.response.url?.lastPathComponent else { return nil }
        return UIImage(data: cachedResponse.data)
    }
        
    private func getImageURL(with endpoint: String) async throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/w500\(endpoint)"
        guard let url = components.url else { throw NetworkError.invalidURL }
        return url
    }
}
