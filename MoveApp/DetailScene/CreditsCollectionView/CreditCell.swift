//
//  CreditCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 24.05.2022.
//

import UIKit

class CreditCell: BaseCollectionViewCell {
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
        label.font = .boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    private lazy var jobLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    var viewModel: CreditCellViewModelProtocol! {
        didSet {
            setup()
        }
    }
    override func prepareForReuse() {
        imageView.image = nil
    }
    private func setup() {
        addSubviews([imageView, nameLabel, jobLabel])
        setupConstraint()
        setImage()
        nameLabel.text = viewModel.name
        jobLabel.text = viewModel.job
    }
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.5),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            jobLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            jobLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            jobLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    private func setImage() {
        if let imageURL = viewModel.profilePath {
            imageView.fetchImage(with: imageURL)
        }
    }
}
