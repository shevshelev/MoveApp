//
//  MovieViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

protocol MovieViewControllerInputProtocol: AnyObject {
    func reloadData()
}

protocol MovieViewControllerOutputProtocol {
    init(view: MovieViewControllerInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
}

class MovieViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MovieViewController: MovieViewControllerInputProtocol {
    func reloadData() {
        
    }
}
