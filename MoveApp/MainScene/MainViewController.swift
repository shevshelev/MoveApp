//
//  MainViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import UIKit

protocol MainViewControllerInputProtocol: AnyObject {
    func reloadData(for sections: [MainMovieSectionViewModel])
}

protocol MainViewControllerOutputProtocol {
    init(view: MainViewControllerInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
}

final class MainViewController: BaseViewController {
    
    var presenter: MainViewControllerOutputProtocol!
    

    private var sections: [MainMovieSectionViewModel] = []
    private var dataSource: UICollectionViewDiffableDataSource<MainMovieSectionViewModel, MovieCellViewModel>?
    
    private lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: createCompositionalLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(collectionView)
        createDataSource()
        presenter.viewDidLoad()
    }
    
    override func setupCollectionView(_ collectionView: UICollectionView) {
        super.setupCollectionView(collectionView)
        collectionView.registerCells(
            [MainMovieCell(), MainNowPlayingMovieCell()],
            and: MainMovieSection()
        )
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MainMovieSectionViewModel, MovieCellViewModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
            switch self.sections[indexPath.section].type {
            case .nowPlaying:
                let viewModel = self.sections[indexPath.section].items[indexPath.item]
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainNowPlayingMovieCell().reuseId,
                    for: indexPath
                ) as? MainNowPlayingMovieCell
                cell?.viewModel = viewModel
                return cell
            default:
                let viewModel = self.sections[indexPath.section].items[indexPath.item]
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainMovieCell().reuseId,
                    for: indexPath
                ) as? MainMovieCell
                cell?.viewModel = viewModel
                return cell
            }
        })
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MainMovieSection().reuseId,
                for: indexPath
            ) as? MainMovieSection else {return nil}
            guard let firstMovie = self.dataSource?
                .itemIdentifier(for: indexPath) else { return nil }
            guard let viewModel = self.dataSource?.snapshot()
                .sectionIdentifier(containingItem: firstMovie) else { return nil }
            sectionHeader.viewModel = viewModel
            return sectionHeader
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MainMovieSectionViewModel, MovieCellViewModel>()
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
                return self.createMovieSection(withBigItems: true)
            default:
                return self.createMovieSection(withBigItems: false)
            }
        }
        return layout
    }
    
    private func createMovieSection(withBigItems: Bool) -> NSCollectionLayoutSection {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Title: \(sections[indexPath.section].items[indexPath.item].title)")
    }
}



// MARK: - MainViewControllerInputProtocol

extension MainViewController: MainViewControllerInputProtocol {
    func reloadData(for sections: [MainMovieSectionViewModel]) {
        self.sections = sections
        reloadData()
    }
}
