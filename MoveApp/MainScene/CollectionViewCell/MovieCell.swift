//
//  MovieCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let reuseId = "MovieCell"
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.3)
        label.textColor = .white
        label.text = "Title"
        return label
    }()
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    func setup(with imageEndpoint: String) {
        Task {
            try await movieImageView.fetchImage(with:imageEndpoint)
        }
        backgroundColor = .systemRed
        addSubviews([movieImageView, titleLabel])
//        addSubview(movieImageView)
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowOpacity = 0.8
        movieImageView.setConstraintsToSuperView()
        titleLabel.setConstraintsToSuperView(top: nil, left: 0, right: nil, bottom: 0)
    }
}
