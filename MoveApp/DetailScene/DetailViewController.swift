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
    var titleLogo: String? { get }
    var originalTitle: String? { get }
    var tagline: String? { get }
    var voteAverage: Double?
    var description: String { get }
    var images: [ImageCellViewModelProtocol] { get }
    init(view: DetailViewControllerInputProtocol)
    func viewDidLoad()
    func didTapFavouriteButton()
}

class DetailViewController: BaseViewController {
    
    var presenter: DetailViewControllerOutputProtocol!
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell().reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = view.backgroundColor
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var gradientView = UIView()
    
    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 60)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var originalLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    private lazy var taglineLabel: UILabel = {
       let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var voteLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .systemGray.withAlphaComponent(0.3)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews([imagesCollectionView, scrollView])
        scrollView.addSubviews([gradientView, originalLabel, taglineLabel, voteLabel])
        presenter.viewDidLoad()
//        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupNavBar() {
        super.setupNavBar()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            landscapeImagePhone: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(buttonTaped)
        )
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesCollectionView.heightAnchor.constraint(
                equalTo: imagesCollectionView.widthAnchor,
                multiplier: 0.5642
            ),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gradientView.bottomAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 20),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 90),
            
            originalLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor),
            originalLabel.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            originalLabel.widthAnchor.constraint(equalTo: gradientView.widthAnchor),
            originalLabel.heightAnchor.constraint(equalToConstant: 10),
            
            taglineLabel.topAnchor.constraint(equalTo: gradientView.bottomAnchor),
            taglineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taglineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taglineLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 15),
            
            voteLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 5),
//            voteLabel.
        ])
    }
    
    @objc private func buttonTaped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setVoteLabel() {
        guard let vote = presenter.voteAverage else { return }
        voteLabel.textColor = vote < 3.0 ? .systemRed : vote < 8.0 ? .systemGray : .systemGreen
        voteLabel.text = String(format: "%.2f", vote)
    }
    
    private func setTitle() {
        addVerticalGradientLayer()
        originalLabel.text = presenter.originalTitle
        if let logoEndpoint = presenter.titleLogo {
            gradientView.addSubview(titleImage)
            titleImage.setConstraintsToSuperView(top: 10, left: 0, right: 0, bottom: -10)
            titleImage.fetchImage(with: logoEndpoint)
        } else {
            gradientView.addSubview(titleLabel)
            titleLabel.setConstraintsToSuperView()
            titleLabel.text = presenter.title
        }
    }
    
    private func addVerticalGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [
            UIColor.clear.cgColor,
            view.backgroundColor?.cgColor ?? UIColor().cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradientView.layer.addSublayer(gradient)

    }
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell().reuseId, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        return cell
    }
}

extension DetailViewController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let viewModel = presenter.images[indexPath.item]
        guard let cell = cell as? ImageCell else { return }
        cell.viewModel = viewModel
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: imagesCollectionView.frame.width,
            height: imagesCollectionView.frame.height
        )
    }
}

extension DetailViewController: DetailViewControllerInputProtocol {
    func reloadData() {
        print(presenter.title)
        print(presenter.description)
//        viewWillLayoutSubviews()
        taglineLabel.text = presenter.tagline
        setTitle()
        imagesCollectionView.reloadData()
        
    }
}
