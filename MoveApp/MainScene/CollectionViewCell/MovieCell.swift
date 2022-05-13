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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with imageEndpoint: String) {
        backgroundColor = .systemRed
        addSubview(movieImageView)
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowOpacity = 0.8
        movieImageView.setConstraintsToSuperView()
        print("Setup")
        Task {
            try await movieImageView.fetchImage(with:imageEndpoint)
            print("Task")
        }
    }
}
