//
//  MoviePresenter.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 15.05.2022.
//

import Foundation

struct MoviePresenterDataStore {
    let latest: Film
    let nowPlaying: [MovieModelProtocol]
    let popular: [MovieModelProtocol]
    let topRated: [MovieModelProtocol]
    let upcoming: [MovieModelProtocol]
}

final class MoviePresenter: MovieViewControllerOutputProtocol {
    
    private unowned let view: MovieViewControllerInputProtocol
    
    init(view: MovieViewControllerInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func didTapCell(at indexPath: IndexPath) {
        
    }
}

extension MoviePresenter: MovieInteractorOutputProtocol {
    func objectsDidReceive(with dataStore: MoviePresenterDataStore) {
//        let sections: 
    }
    
    
}
