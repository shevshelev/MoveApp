//
//  TabBarButton.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

final class TabBarButton: UIButton {
    
    private let image: UIImage?
    private let selectedImage: UIImage?
    private let title: String?
    
    var _isSelected: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    init(image: UIImage?, selectedImage: UIImage?, title: String?) {
        self.image = image
        self.selectedImage = selectedImage
        self.title = title
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateStyle() {
        tintColor = _isSelected ? .white : .white.withAlphaComponent(0.25)
        widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.4).isActive = _isSelected
        widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.15).isActive = !_isSelected
        
        setImage(_isSelected ? selectedImage : image, for: .normal)
        setTitle(_isSelected ? title : nil, for: .normal)
    }
}
