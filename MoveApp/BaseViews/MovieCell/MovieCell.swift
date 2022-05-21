//
//  MovieCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    var reuseId: String {
        "MovieCell"
    }
    
    var viewModel: MovieCellViewModelProtocol! {
        didSet {
            setup()
            setImage()
        }
    }
    
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
    
    func setup() {
        addSubview(movieImageView)
        movieImageView.setConstraintsToSuperView()
        backgroundColor = .systemRed
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowOpacity = 0.8
    }
    
    func setImage() {
        if let posterURl = viewModel.posterURL {
            movieImageView.fetchImage(with:posterURl)
        }
    }
}
