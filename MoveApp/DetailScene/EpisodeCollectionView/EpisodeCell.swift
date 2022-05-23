//
//  EpisodeCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 23.05.2022.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    var reuseId: String {
        "EpisodeCell"
    }
    var viewModel: EpisodeCellViewModelProtocol! {
        didSet {
            setup()
        }
    }
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    private func setup() {
        addSubviews([imageView, nameLabel])
        setupConstraint()
        setImage()
        nameLabel.text = viewModel.name
        
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5625),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    private func setImage() {
        if let imageURL = viewModel.imagePath {
            imageView.fetchImage(with: imageURL)
        }
    }
}
