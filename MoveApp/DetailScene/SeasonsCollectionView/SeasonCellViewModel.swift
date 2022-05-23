//
//  SeasonCellViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 23.05.2022.
//

import Foundation

protocol SeasonCellViewModelProtocol {
    var name: String? { get }
    var episodes: Int? { get }
    var seasonNumber: Int? { get }
    init(season: Season)
}

class SeasonCellViewModel: SeasonCellViewModelProtocol {
    
    private let season: Season
    
    var episodes: Int? {
        season.episodeCount
    }
    
    var name: String? {
        season.name
    }
    
    var seasonNumber: Int? {
        season.seasonNumber
    }
    
    required init(season: Season) {
        self.season = season
    }
    
}
