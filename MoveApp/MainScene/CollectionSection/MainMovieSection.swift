//
//  MainMovieSection.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

class MainMovieSection: BaseCollectionSection {
    
    override var reuseId: String {
        "MainMovieSection"
    }
    private let title = UILabel()
    
    var viewModel: MainMovieSectionViewModelProtocol! {
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
