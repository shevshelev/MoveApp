//
//  ImageCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 21.05.2022.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    private let color = UIColor(
        red: 89 / 255,
        green: 41 / 255,
        blue: 149 / 255,
        alpha: 1
    )
    
    var reuseId: String {
        "ImageCell"
    }
    
    var viewModel: ImageCellViewModelProtocol! {
        didSet {
            setup()
        }
    }
    
    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    private func setup() {
        addSubview(imageView)
        imageView.setConstraintsToSuperView()
        backgroundColor = color
        imageView.fetchImage(with: viewModel.imageEndpoin ?? "")
    }
}
