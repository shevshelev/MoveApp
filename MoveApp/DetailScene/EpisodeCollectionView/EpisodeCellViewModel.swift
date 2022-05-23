//
//  EpisodeCellViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 23.05.2022.
//

import Foundation

protocol EpisodeCellViewModelProtocol {
    var imagePath: String? { get }
    var name: String? { get }
    init(episode: Episode)
}

class EpisodeCellViewModel: EpisodeCellViewModelProtocol {
    
    private let episode: Episode
    
    var imagePath: String? {
        episode.stillPath
    }
    
    var name: String? {
        episode.name
    }
    
    required init(episode: Episode) {
        self.episode = episode
    }
    
    
}
