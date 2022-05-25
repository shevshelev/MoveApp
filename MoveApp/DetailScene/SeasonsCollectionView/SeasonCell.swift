//
//  SeasonCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 23.05.2022.
//

import UIKit

class SeasonCell: BaseCollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var selectView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.selectView.isHidden = !self.isSelected
            }
        }
    }
    var viewModel: SeasonCellViewModelProtocol! {
        didSet {
            setup()
        }
    }
    
    private func setup() {
        selectView.isHidden = true
        addSubviews([selectView, nameLabel])
        selectView.setConstraintsToSuperView()
        nameLabel.setConstraintsToSuperView()
        nameLabel.text = viewModel.name
    }
}
