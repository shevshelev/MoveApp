//
//  Utils.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import Foundation

class Utils {
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
        
        static let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            return dateFormatter
        }()
}
