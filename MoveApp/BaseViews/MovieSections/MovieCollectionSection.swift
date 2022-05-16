//
//  BaseCollectionSection.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import UIKit

protocol MovieSectionViewModelProtocol {
    var type: MovieSectionType { get }
    var items: [MovieCellViewModel] { get }
    init(type: MovieSectionType, items: [MovieModelProtocol])
}

class MovieCollectionSection: UICollectionReusableView {
    
    private let title = UILabel()
    
    var reuseId: String {
        "MovieCollectionSection"
    }
    
    var viewModel: MovieSectionViewModelProtocol! {
        didSet {
            setup()
        }
    }
        
    private func setup() {
        addSubview(title)
        title.setConstraintsToSuperView()
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 20)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = viewModel.type.rawValue
    }
}
