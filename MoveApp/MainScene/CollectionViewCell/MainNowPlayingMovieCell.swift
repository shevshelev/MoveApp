//
//  MainNowPlayingMovieCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 14.05.2022.
//

import UIKit

class MainNowPlayingMovieCell: MainMovieCell {
    
    override var reuseId: String {
        "NowNowPlayingMovieCell"
    }
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.3)
        label.textColor = .white
        return label
    }()
    
    override func setup() {
        super.setup()
        titleLabel.text = " \(viewModel.title)"
        addSubview(titleLabel)
        titleLabel.setConstraintsToSuperView(top: nil, left: 0, right: nil, bottom: 0)
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
    }
    
    override func setImage() {
        Task {
            if let backdropURL = viewModel.backdropURL {
                try await movieImageView.fetchImage(with:backdropURL)
            } else {
                if let posterURl = viewModel.posterURL {
                    try await movieImageView.fetchImage(with:posterURl)
                }
            }
        }
    }
}
