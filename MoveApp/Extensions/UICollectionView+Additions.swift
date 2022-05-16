//
//  UICollectionView+Additions.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import UIKit

extension UICollectionView {
    func registerCells(_ cells: [MovieCell], and header: MovieCollectionSection) {
        cells.forEach {
            register(type(of: $0), forCellWithReuseIdentifier: $0.reuseId)
        }
        register(type(of: header), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: header.reuseId)
    }
}
