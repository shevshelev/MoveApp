//
//  DetailViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 18.05.2022.
//

import UIKit

protocol DetailViewControllerInputProtocol: AnyObject {
    func reloadData(with title: String, and endPoint: String?)
}

protocol DetailViewControllerOutputProtocol {
    init(view: DetailViewControllerInputProtocol)
    func viewDidLoad()
    func didTapFavouriteButton()
}

class DetailViewController: BaseViewController {
    
    var presenter: DetailViewControllerOutputProtocol!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(titleImage)
        presenter.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            titleImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
//            scrollView.bottomAnchor.constraint(equalTo: titleImage.bottomAnchor)
            
        ])
    }
}

extension DetailViewController: DetailViewControllerInputProtocol {
    func reloadData(with title: String, and endpoint: String?) {
        Task {
            try await self.titleImage.fetchImage(with: endpoint ?? "")
        }
        self.title = title
    }
}
