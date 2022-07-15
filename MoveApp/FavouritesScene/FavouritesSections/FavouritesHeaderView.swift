//
//  FavouritesHeaderView.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 08.06.2022.
//

import UIKit

protocol FavouritesHeaderViewDelegate: AnyObject {
    func expandedSection(number: Int)
}

class FavouritesHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: FavouritesHeaderViewDelegate?
    var reuseId: String {
        "\(type(of: self))"
    }
    
    var viewModel: ExpandedSectionViewModel! {
        didSet {
            setup()
        }
    }
    
    private lazy var label: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tapHeader(sender:)), for: .touchUpInside)
        return button
    }()
    
    private func setup() {
        setupConstraints()
        label.text = viewModel.type.rawValue
    }
    
    private func setupConstraints() {
        addSubviews([label, button])
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            button.widthAnchor.constraint(equalTo: heightAnchor),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: button.leadingAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    @objc private func tapHeader(sender: UIButton) {
        delegate?.expandedSection(number: viewModel.number )
    }
    
    func rotateImage(_ expanded: Bool) {
        if expanded {
            button.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } else {
            button.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
        }
    }
}
