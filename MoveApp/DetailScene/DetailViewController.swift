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
    var cast: [CreditCellViewModelProtocol] { get }
    init(view: DetailViewControllerInputProtocol)
    func viewDidLoad()
    func didTapFavouriteButton()
    func didTapSectionCell(at indexPath: IndexPath)
}

class DetailViewController: BaseViewController {
    
    private lazy var imagesCollectionView = createCollectionView(
        minimumLineSpacing: 0,
        cell: ImageCell(),
        allowSelection: false
    )
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
//        scrollView.bounces = false
//        scrollView.zoom(to: imagesCollectionView.frame, animated: true)
        
        scrollView.delegate = self
        return scrollView
    }()
    private lazy var gradientView = UIView()
    private lazy var sublayerView: UIView = {
        let view = UIView()
        view.backgroundColor = self.view.backgroundColor
        return view
    }()
    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titleLabel = createLabel(
        font: .boldSystemFont(ofSize: 60),
        alignment: .center,
        color: .white,
        withSublayer: false, withTitle: nil
    )
    private lazy var originalLabel = createLabel(
        font: .systemFont(ofSize: 12),
        alignment: .center,
        color: .systemGray,
        withSublayer: false, withTitle: nil
    )
    private lazy var taglineLabel = createLabel(
        font: .systemFont(ofSize: 17),
        alignment: .center,
        color: .white,
        withSublayer: false, withTitle: nil
    )
    private lazy var voteLabel = createLabel(
        font: .systemFont(ofSize: 30),
        alignment: .center,
        color: .systemGray.withAlphaComponent(0.3),
        withSublayer: true,
        withTitle: nil
    )
    private lazy var descriptionLabel = createLabel(
        font: .systemFont(ofSize: 17),
        alignment: .left,
        color: .white,
        withSublayer: false,
        withTitle: nil
    )
    private lazy var rateButton = createButton(with: "Оценить!")
    private lazy var favouriteButton = createButton(with: "В избранное!")
    private lazy var overviewLabel = createLabel(
        font: .systemFont(ofSize: 17),
        alignment: .left,
        color: .white,
        withSublayer: false,
        withTitle: nil
    )
    private lazy var seasonsCollectionView = createCollectionView(
        minimumLineSpacing: 10,
        cell: SeasonCell(),
        allowSelection: true
    )
    private lazy var episodeCollectionView = createCollectionView(
        minimumLineSpacing: 10,
        cell: EpisodeCell(),
        allowSelection: false
    )
    private lazy var budgetView = createLabel(
        font: .boldSystemFont(ofSize: 27),
        alignment: .center,
        color: .white,
        withSublayer: true,
        withTitle: "Bubget:"
    )
    private lazy var revenueView = createLabel(
        font: .boldSystemFont(ofSize: 27),
        alignment: .center,
        color: .white,
        withSublayer: true,
        withTitle: "Revenu:"
    )

    private lazy var castCollectionView = createCollectionView(
        minimumLineSpacing: 10,
        cell: CreditCell(),
        allowSelection: false
    )
    
    var presenter: DetailViewControllerOutputProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews([
//            imagesCollectionView,
            scrollView
        ])
        scrollView.addSubviews([
            imagesCollectionView,
            gradientView, sublayerView, originalLabel, taglineLabel, voteLabel, descriptionLabel, rateButton, favouriteButton, overviewLabel, castCollectionView])
        presenter.viewDidLoad()
    }
    
    override func setupNavBar() {
        super.setupNavBar()
//        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
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

            imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            imagesCollectionView.bottomAnchor.constraint(equalTo: gradientView.centerYAnchor),
            
            gradientView.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.width * 0.5642),
//            gradientView.centerYAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 90),
            
            sublayerView.topAnchor.constraint(equalTo: gradientView.bottomAnchor),
            sublayerView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor),
            sublayerView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor),
            
            
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
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            castCollectionView.leadingAnchor.constraint(equalTo: overviewLabel.leadingAnchor),
            castCollectionView.trailingAnchor.constraint(equalTo: overviewLabel.trailingAnchor),
            castCollectionView.heightAnchor.constraint(equalToConstant: 200),
            castCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100),
            
            sublayerView.bottomAnchor.constraint(equalTo: castCollectionView.bottomAnchor, constant: -300)
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
        scrollView.zoom(to: imagesCollectionView.frame, animated: true)
        addVerticalGradientLayer()
        originalLabel.text = presenter.originalTitle
        if let logoEndpoint = presenter.titleLogo {
            print(logoEndpoint)
            gradientView.addSubview(titleImage)
            titleImage.setConstraintsToSuperView(top: 10, left: 6, right: -6, bottom: -10)
            titleImage.fetchImage(with: logoEndpoint)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.titleImage.image == nil {
                    self.gradientView.addSubview(self.titleLabel)
                    self.titleLabel.setConstraintsToSuperView()
                    self.titleLabel.text = self.presenter.title
                }
            }
        } else {
            gradientView.addSubview(titleLabel)
            titleLabel.setConstraintsToSuperView()
            titleLabel.text = presenter.title
        }
    }
    
    private func setSeasonsCollectionView() {
        if let seasons = presenter.seasons, !seasons.isEmpty {
            print("-----------")
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
                episodeCollectionView.heightAnchor.constraint(equalToConstant: 100),
                castCollectionView.topAnchor.constraint(equalTo: episodeCollectionView.bottomAnchor, constant: 20)
            ])
        } else {
            print("++++++++++")
//            castCollectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 5).isActive = true
        }
    }
    
    private func setBudgetLabel() {
        if presenter.budget != nil, presenter.revenue != nil {
            scrollView.addSubviews([budgetView, revenueView])
            budgetView.text = presenter.budget
            revenueView.text = presenter.revenue

            NSLayoutConstraint.activate([
                budgetView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 5),
                budgetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                budgetView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -20),
                budgetView.heightAnchor.constraint(equalToConstant: 45),
                
                revenueView.topAnchor.constraint(equalTo: budgetView.topAnchor),
                revenueView.leadingAnchor.constraint(equalTo: budgetView.trailingAnchor, constant: 20),
                revenueView.widthAnchor.constraint(equalTo: budgetView.widthAnchor),
                revenueView.heightAnchor.constraint(equalTo: budgetView.heightAnchor),
                
                castCollectionView.topAnchor.constraint(equalTo: budgetView.bottomAnchor, constant: 5)
            ])
        } else {
            castCollectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 5).isActive = true
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
    
    
    
    
    
    
    
    
    
    
    private func createCollectionView(minimumLineSpacing: CGFloat, cell: BaseCollectionViewCell, allowSelection: Bool) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(type(of: cell), forCellWithReuseIdentifier: cell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = view.backgroundColor
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }
    
    private func createLabel(font: UIFont, alignment: NSTextAlignment, color: UIColor, withSublayer: Bool, withTitle: String?) -> UILabel {
        let label = UILabel()
        if withSublayer {
            label.backgroundColor = .systemGray.withAlphaComponent(0.3)
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 15
        }
        if let title = withTitle {
            let titleLabel = createLabel(
                font: .systemFont(ofSize: 10),
                alignment: .left,
                color: .white,
                withSublayer: false,
                withTitle: nil
            )
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            label.addSubview(titleLabel)
            titleLabel.text = title
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: label.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 10)
            ])
            updateViewConstraints()
        }
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = alignment
        label.textColor = color
        label.numberOfLines = 0
        return label
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.5, height: 3)
        button.layer.shadowOpacity = 0.8
        return button
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
            return presenter.cast.count
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell().reuseId, for: indexPath) as? CreditCell else { return UICollectionViewCell() }
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
            let viewModel = presenter.cast[indexPath.item]
            guard let cell = cell as? CreditCell else { return }
            cell.viewModel = viewModel
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsCollectionView {
            presenter.didTapSectionCell(at: indexPath)
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imagesCollectionView.visibleCells.first
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
        case episodeCollectionView:
            return CGSize(width: 100, height: 100)
        default:
            return CGSize(width: 100, height: 200)
        }
    }
}

extension DetailViewController: DetailViewControllerInputProtocol {
    func reloadData() {

        overviewLabel.text = presenter.overview
        taglineLabel.text = presenter.tagline
        descriptionLabel.text = presenter.description
        setBudgetLabel()
        setTitle()
        setVoteLabel()
        setSeasonsCollectionView()
        imagesCollectionView.reloadData()
        castCollectionView.reloadData()
    }
    
    func reloadEpisodes() {
        episodeCollectionView.reloadData()
        print("+_+_+_+")
        episodeCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
    }
}
