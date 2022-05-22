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
    var voteAverage: Double? { get }
    var description: String { get }
    var overview: String? { get }
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
        collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
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
        label.font = .boldSystemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .systemGray.withAlphaComponent(0.3)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private lazy var rateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Оценить!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("В избранное!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    private lazy var overviewLabel: UILabel = {
       let label = UILabel()
//        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews([imagesCollectionView, scrollView, descriptionLabel])
        scrollView.addSubviews([gradientView, originalLabel, taglineLabel, voteLabel, rateButton, favouriteButton, overviewLabel])
        presenter.viewDidLoad()
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
            imagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
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
            
            voteLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 20),
            voteLabel.heightAnchor.constraint(equalToConstant: 45),
            voteLabel.widthAnchor.constraint(equalToConstant: 90),
            voteLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 4 - 30),
            
            descriptionLabel.topAnchor.constraint(equalTo: voteLabel.topAnchor),
            descriptionLabel.heightAnchor.constraint(equalTo: voteLabel.heightAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: voteLabel.trailingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            rateButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            rateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            rateButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
            rateButton.heightAnchor.constraint(equalToConstant: 40),
            
            favouriteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            favouriteButton.leadingAnchor.constraint(equalTo: rateButton.trailingAnchor, constant: 10),
            favouriteButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
            favouriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            overviewLabel.topAnchor.constraint(equalTo: favouriteButton.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    @objc private func buttonTaped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setVoteLabel() {
        guard let vote = presenter.voteAverage else { return }
        voteLabel.textColor = vote < 3.0 ? .systemRed : vote < 7.0 ? .systemGray : .systemGreen
        voteLabel.text = String(format: "%.2f", vote)
    }
    
    private func setTitle() {
        addVerticalGradientLayer()
        originalLabel.text = presenter.originalTitle
        if let logoEndpoint = presenter.titleLogo {
            gradientView.addSubview(titleImage)
            titleImage.setConstraintsToSuperView(top: 10, left: 6, right: -6, bottom: -10)
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
        print(presenter.images.count)
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
        overviewLabel.text = presenter.overview
        taglineLabel.text = presenter.tagline
        descriptionLabel.text = presenter.description
        setTitle()
        setVoteLabel()
        imagesCollectionView.reloadData()
        
    }
}
