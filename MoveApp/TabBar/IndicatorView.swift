//
//  IndicatorView.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

final class IndicatorView: UIView {
    private let view = UIView()
    private let offset: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubviews([view])
        view.setConstraintsToSuperView(top: offset, left: offset, right: -offset, bottom: -offset)
        view.layer.cornerRadius = 17.5
        view.backgroundColor = .systemRed
    }
}
