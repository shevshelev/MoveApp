//
//  UIView+Additions.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        for view in subviews {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func setConstraintsToSuperView(top: CGFloat? = 0, left: CGFloat? = 0, right: CGFloat? = 0, bottom: CGFloat? = 0) {
        guard let view = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        }
        if let left = left {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left).isActive = true
        }
        if let right = right {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        }
    }
}
