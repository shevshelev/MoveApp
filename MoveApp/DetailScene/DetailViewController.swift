//
//  DetailViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 18.05.2022.
//

import UIKit

protocol DetailViewControllerInputProtocol: AnyObject {
    func reloadData()
    func reloadEpisodes()
}

protocol DetailViewControllerOutputProtocol {
    var title: String? { get }
    var titleLogo: String? { get }
    var originalTitle: String { get }
    var tagline: String? { get }
    var voteAverage: Double? { get }
    var description: String { get }
    var overview: String? { get }
    var seasons: [SeasonCellViewModelProtocol]? { get }
    var episodes: [EpisodeCellViewModelProtocol] { get }
    var budget: String? { get }
    var revenue: String? { get }
    var images: [ImageCellViewModelProtocol] { get }
    init(view: DetailViewControllerInputProtocol)
    func viewDidLoad()
    func didTapFavouriteButton()
    func didTapSectionCell(at indexPath: IndexPath)
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
        collectionView.contentInsetAdjustmentBehavior = .never
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
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private lazy var seasonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        collectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell().reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = view.backgroundColor
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var episodeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell().reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = view.backgroundColor
        collectionView.allowsSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var budgetView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var revenueView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        return view
    }()
    private lazy var budgetTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = "Budget:"
        label.textColor = .white
        return label
    }()
    private lazy var revenueTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = "Revenue:"
        label.textColor = .white
        return label
    }()
    private lazy var budgetLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemRed
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    private lazy var revenueLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
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
    
    private func setSeasonsCollectionView() {
        if let seasons = presenter.seasons, !seasons.isEmpty {
            scrollView.addSubviews([seasonsCollectionView, episodeCollectionView])
            seasonsCollectionView.delegate?.collectionView?(seasonsCollectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
            NSLayoutConstraint.activate([
                seasonsCollectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
                seasonsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                seasonsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                seasonsCollectionView.heightAnchor.constraint(equalToConstant: 30),
                
                episodeCollectionView.topAnchor.constraint(equalTo: seasonsCollectionView.bottomAnchor),
                episodeCollectionView.leadingAnchor.constraint(equalTo: seasonsCollectionView.leadingAnchor),
                episodeCollectionView.trailingAnchor.constraint(equalTo: seasonsCollectionView.trailingAnchor),
                episodeCollectionView.heightAnchor.constraint(equalToConstant: 150)
            ])
        }
    }
    
    private func setBudgetLabel() {
        if let budget = presenter.budget, let revenue = presenter.revenue {
            scrollView.addSubviews([budgetView, revenueView])
            budgetView.addSubviews([budgetTitle,budgetLabel])
            revenueView.addSubviews([revenueTitle, revenueLabel])
            revenueLabel.text = "\(revenue) $"
            budgetLabel.text = "\(budget) $"
            revenueLabel.textColor = budget < revenue ? .systemGreen : .systemRed
            NSLayoutConstraint.activate([
                budgetView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
                budgetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                budgetView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -20),
                budgetView.heightAnchor.constraint(equalToConstant: 60),
                
                revenueView.topAnchor.constraint(equalTo: budgetView.topAnchor),
                revenueView.leadingAnchor.constraint(equalTo: budgetView.trailingAnchor, constant: 20),
                revenueView.widthAnchor.constraint(equalTo: budgetView.widthAnchor),
                revenueView.heightAnchor.constraint(equalTo: budgetView.heightAnchor),
                
                budgetTitle.topAnchor.constraint(equalTo: budgetView.topAnchor, constant: 5),
                budgetTitle.leadingAnchor.constraint(equalTo: budgetView.leadingAnchor, constant: 5),
                budgetTitle.widthAnchor.constraint(equalTo: budgetView.widthAnchor, constant: -10),
                budgetTitle.heightAnchor.constraint(equalToConstant: 12),
                
                revenueTitle.topAnchor.constraint(equalTo: revenueView.topAnchor, constant: 5),
                revenueTitle.leadingAnchor.constraint(equalTo: revenueView.leadingAnchor, constant: 5),
                revenueTitle.widthAnchor.constraint(equalTo: revenueView.widthAnchor, constant: -10),
                revenueTitle.heightAnchor.constraint(equalToConstant: 12),
                
                budgetLabel.topAnchor.constraint(equalTo: budgetTitle.bottomAnchor),
                budgetLabel.leadingAnchor.constraint(equalTo: budgetTitle.leadingAnchor),
                budgetLabel.trailingAnchor.constraint(equalTo: budgetTitle.trailingAnchor),
                
                revenueLabel.topAnchor.constraint(equalTo: revenueTitle.bottomAnchor),
                revenueLabel.leadingAnchor.constraint(equalTo: revenueTitle.leadingAnchor),
                revenueLabel.trailingAnchor.constraint(equalTo: revenueTitle.trailingAnchor),
            ])
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
        switch collectionView {
        case imagesCollectionView:
            return presenter.images.count
        case seasonsCollectionView:
            return presenter.seasons?.count ?? 0
        case episodeCollectionView:
            return presenter.episodes.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case imagesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell().reuseId, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
            return cell
        case seasonsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell().reuseId, for: indexPath) as? SeasonCell else { return UICollectionViewCell() }
            return cell
        case episodeCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell().reuseId, for: indexPath) as? EpisodeCell else { return UICollectionViewCell() }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell().reuseId, for: indexPath) as? SeasonCell else { return UICollectionViewCell() }
            return cell
        }
        
    }
}

extension DetailViewController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case imagesCollectionView:
            let viewModel = presenter.images[indexPath.item]
            guard let cell = cell as? ImageCell else { return }
            cell.viewModel = viewModel
        case seasonsCollectionView:
            let viewModel = presenter.seasons?[indexPath.item]
            guard let cell = cell as? SeasonCell else { return }
            cell.viewModel = viewModel
        case episodeCollectionView:
            let viewModel = presenter.episodes[indexPath.item]
            guard let cell = cell as? EpisodeCell else { return }
            cell.viewModel = viewModel
        default:
            let viewModel = presenter.seasons?[indexPath.item]
            guard let cell = cell as? SeasonCell else { return }
            cell.viewModel = viewModel
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsCollectionView {
            presenter.didTapSectionCell(at: indexPath)
        }
    }
    
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case imagesCollectionView:
            return CGSize(
                width: imagesCollectionView.frame.width,
                height: imagesCollectionView.frame.height
            )
        case seasonsCollectionView:
            return CGSize(width: 100, height: 30)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
}

extension DetailViewController: DetailViewControllerInputProtocol {
    func reloadData() {
        overviewLabel.text = presenter.overview
        taglineLabel.text = presenter.tagline
        descriptionLabel.text = presenter.description
        setBudgetLabel()
        setSeasonsCollectionView()
        setTitle()
        setVoteLabel()
        imagesCollectionView.reloadData()
        
    }
    
    func reloadEpisodes() {
        episodeCollectionView.reloadData()
        episodeCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
    }
}
