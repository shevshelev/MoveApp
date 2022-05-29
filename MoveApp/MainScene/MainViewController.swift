//
//  MainViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import UIKit

protocol MainViewControllerInputProtocol: AnyObject {
    func reloadData(for sections: [MovieSectionViewModel])
}

protocol MainViewControllerOutputProtocol {
    var view: MainViewControllerInputProtocol { get }
    var sections: [MovieSectionViewModel] { get }
    init(view: MainViewControllerInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
}

final class MainViewController: BaseViewController {
    
    var includeLatest: Bool
    var presenter: MainViewControllerOutputProtocol!
    
    private var sections: [MovieSectionViewModel] = []
    private var dataSource: UICollectionViewDiffableDataSource<MovieSectionViewModel, MovieCellViewModel>?
        
    private lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: createCompositionalLayout()
    )
    
    init(includeLatest: Bool) {
        self.includeLatest = includeLatest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseCollectionView(collectionView)
        presenter.viewDidLoad()
    }
    
    override func setupNavBar() {
        super.setupNavBar()
    }
    
    override func setupBaseCollectionView(_ collectionView: UICollectionView) {
        super.setupBaseCollectionView(collectionView)
        collectionView.registerCells(
            [MovieCell(), MovieBigCell()],
            and: MovieCollectionSection()
        )
        dataSource = createDataSource(MovieSectionViewModel.self, MovieCellViewModel.self, for: collectionView) {[unowned self] collectionView, indexPath, itemIdentifier in
            switch sections[indexPath.section].type {
            case .nowPlaying:
                if includeLatest {
                    return createCell(type: MovieCell.self, in: collectionView, at: indexPath)
                } else {
                    return createCell(type: MovieBigCell.self, in: collectionView, at: indexPath)
                }
            case .latest:
                return createCell(type: MovieBigCell.self, in: collectionView, at: indexPath)
            default:
                return createCell(type: MovieCell.self, in: collectionView, at: indexPath)
            }
        }
        createSupplementaryViewProvider(for: dataSource, with: MovieCollectionSection())
    }
    
    private func createCell<T: MovieCell>(type: T.Type, in collectionView: UICollectionView, at indexPath: IndexPath) -> T? {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: T().reuseId,
            for: indexPath) as? T
        return cell
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieSectionViewModel, MovieCellViewModel>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            switch section.type {
            case .nowPlaying:
                return self.createSection(withBigItems: !self.includeLatest)
            case .latest:
                return self.createSection(withBigItems: self.includeLatest)
            default:
                return self.createSection(withBigItems: false)
            }
        }
        return layout
    }
    
    private func createSection(withBigItems: Bool) -> NSCollectionLayoutSection {
        let itemInsets: CGFloat = 8
        let sectionInsets: CGFloat = 12
        let width = UIScreen.main.bounds.width - (itemInsets + sectionInsets) * 2
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(
            top: 0,
            leading: itemInsets,
            bottom: 0,
            trailing: itemInsets
        )
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(withBigItems ? width : width / 3),
            heightDimension: .estimated(withBigItems ? width * 0.6 : width / 2)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutGroupSize,
            subitems: [layoutItem]
        )
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(
            top: sectionInsets,
            leading: sectionInsets,
            bottom: sectionInsets,
            trailing: sectionInsets
        )
        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]
        return layoutSection
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(20)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return layoutSectionHeader
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? MovieCell
        let viewModel = sections[indexPath.section].items[indexPath.item]
        cell?.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapCell(at: indexPath)
        showTabBar()
    }
}

// MARK: - MainViewControllerInputProtocol

extension MainViewController: MainViewControllerInputProtocol {
    func reloadData(for sections: [MovieSectionViewModel]) {
        self.sections = sections
        reloadData()
    }
}
