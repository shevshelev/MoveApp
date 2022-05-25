//
//  123.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 24.05.2022.
//
//
//import Foundation
import UIKit



//private lazy var titleLabel: UILabel = {
//   let label = UILabel()
//    label.font = .boldSystemFont(ofSize: 60)
//    label.adjustsFontSizeToFitWidth = true
//    label.textAlignment = .center
//    label.textColor = .white
//    return label
//}()


private func createButton(with title: String) -> UIButton {
    let button = UIButton()
    button.backgroundColor = .systemRed
    button.setTitle(title, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 20
    return button
}
