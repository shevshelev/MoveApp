//
//  FavouritesSectionViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 08.06.2022.
//

import Foundation

protocol ExpandedSectionsViewModelProtocol {
    var type: MovieSectionType { get }
    var items: [MovieCellViewModel] { get }
    var isExpanded: Bool { get }
    var number: Int { get }
    init(type: MovieSectionType, items: [MovieModelProtocol], isExpanded: Bool, number: Int)
}

class ExpandedSectionViewModel: ExpandedSectionsViewModelProtocol {
    var type: MovieSectionType
    var items: [MovieCellViewModel] = []
    var isExpanded: Bool
    var number: Int
    
    required init(type: MovieSectionType, items: [MovieModelProtocol], isExpanded: Bool, number: Int) {
        self.type = type
        self.isExpanded = isExpanded
        self.number = number
        items.forEach {
            let viewModel = MovieCellViewModel(movie: $0)
            self.items.append(viewModel)
        }
    }
    
    
}
