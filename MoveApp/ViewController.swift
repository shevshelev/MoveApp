//
//  ViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
//    let getSonic = Task {
//        guard let movie = try await NetworkManager.shared.fetchMovie(for: .single(id: 675353)) as? Movie else {return}
//        print(movie.title)
//        print(movie.overview)
//    }
    let getPopular = Task {
        guard let movies = try await NetworkManager.shared.fetchMovie(for: .search(query: "132")) as? MovieResponce else {
            print("123")
            return
        }
//        movies.results.map { print($0.title)}
        print(movies.results.count)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        getPopular
        
    }


}

