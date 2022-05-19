//
//  DetailViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 18.05.2022.
//

import UIKit

protocol DetailViewControllerInputProtocol: AnyObject {
    func reloadData()
}

protocol DetailViewControllerOutputProtocol {
    var title: String? { get }
    var genres: String? { get }
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
        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupNavBar() {
        super.setupNavBar()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), landscapeImagePhone: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(buttonTaped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
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
    
    @objc private func buttonTaped() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: DetailViewControllerInputProtocol {
    func reloadData() {
        print(presenter.title)
        print(presenter.genres)
    }
}
