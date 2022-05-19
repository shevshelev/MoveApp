//
//  MovieBigCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 14.05.2022.
//

import UIKit

class MovieBigCell: MovieCell {
    
    override var reuseId: String {
        "MovieBigCell"
    }
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
                movieImageView.fetchImage(with:backdropURL)
            } else {
                if let posterURl = viewModel.posterURL {
                    movieImageView.fetchImage(with:posterURl)
                } else {
                    DispatchQueue.main.async {
                        self.setupStub()
                    }
                }
            }
        }
    }
    private func setupStub() {
        addSubview(stubLabel)
        NSLayoutConstraint.activate([
            stubLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            stubLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stubLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
        ])
        stubLabel.text = viewModel.title
        titleLabel.text = nil
    }
}
