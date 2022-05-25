//
//  BaseCollectionViewCell.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 24.05.2022.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    var reuseId: String {
        "\(type(of: self))"
    }
}
