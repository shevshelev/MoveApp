//
//  DataManager.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 30.05.2022.
//

import Foundation

protocol DataManagerProtocol {
    func setFavouriteStatus(for type: MovieType, _ id: Int, with status: Bool)
    func getFavouriteStatus(for type: MovieType, _ id: Int) -> Bool
    func setRate(for type: MovieType, _ id: Int, with rate: Double)
    func getRate(for type: MovieType, _ id: Int) -> Double
}

class DataManager: DataManagerProtocol {
    
    static let shared: DataManagerProtocol = DataManager()
    private let userDefaults = UserDefaults()
    private let kFavourite = "Favourite"
    private let kRate = "Rate"
    private init() {}
    
    func setFavouriteStatus(for type: MovieType, _ id: Int, with status: Bool) {
        userDefaults.set(status, forKey: "\(kFavourite)-\(type.rawValue)-\(id)")
    }
    func getFavouriteStatus(for type: MovieType, _ id: Int) -> Bool {
        userDefaults.bool(forKey: "\(kFavourite)-\(type.rawValue)-\(id)")
    }
    func setRate(for type: MovieType, _ id: Int, with rate: Double) {
        userDefaults.set(rate, forKey: "\(kRate)-\(type.rawValue)-\(id)")
    }
    func getRate(for type: MovieType, _ id: Int) -> Double {
        userDefaults.double(forKey: "\(kRate)-\(type.rawValue)-\(id)")
    }
}
