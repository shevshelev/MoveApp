//
//  MainViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 11.05.2022.
//

import UIKit

protocol MainViewControllerInputProtocol: AnyObject {
    func reloadData(for sections: [Section])
}

protocol MainViewControllerOutputProtocol {
    init(view: MainViewControllerInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
}


final class MainViewController: UIViewController {
    
    var presenter: MainViewControllerOutputProtocol!
    let configurator: MainConfigurator = MainConfigurator()
    private var sections: [Section] = []
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
    
    
    private let backgroundColor = UIColor(
        red: 89 / 255,
        green: 41 / 255,
        blue: 149 / 255,
        alpha: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        configurator.configure(with: self)
        setupNavBar()
        setupCollectionView()
        createDataSource()
        reloadData()
        presenter.viewDidLoad()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = backgroundColor
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 30)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 70)]
        navBarAppearance.backgroundColor = backgroundColor
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch self.sections[indexPath.section].type {
            case "nowPlaying":
     
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseId, for: indexPath) as? MovieCell
                if let endpoint = self.sections[indexPath.section].items[indexPath.item].backdropPath {
                    cell?.setup(with: endpoint)
                } else {
                    print("123")
                }
                return cell
            case "popularFilm":
    
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseId, for: indexPath) as? MovieCell
                if let endpoint = self.sections[indexPath.section].items[indexPath.item].posterPath {
                    cell?.setup(with: endpoint)
                } else {
                    print("123")
                }
                return cell
            default:

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseId, for: indexPath) as? MovieCell
                if let endpoint = self.sections[indexPath.section].items[indexPath.item].posterPath {
                    cell?.setup(with: endpoint)
                } else {
                    print("123")
                }
                return cell
            }
        })
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {return nil}
            guard let firstMovie = self.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let sectiion = self.dataSource?.snapshot().sectionIdentifier(containingItem: firstMovie) else { return nil }
            if sectiion.title.isEmpty { return nil }
            sectionHeader.title.text = sectiion.title
            return sectionHeader
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            switch section.type {
            case "nowPlaying":
                return self.createMovieSection(withBigItems: true)
            case "popularFilm":
                return self.createMovieSection(withBigItems: false)
            default:
                return self.createMovieSection(withBigItems: false)
            }
        }
        return layout
    }
    
    private func createMovieSection(withBigItems: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(withBigItems ? 400 : 200), heightDimension: .estimated(200))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = withBigItems ? .groupPaging : .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 12, bottom: 6, trailing: 12)
        
        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]
        
        return layoutSection
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(sections[indexPath.section].items[indexPath.item].id)
    }
}

extension MainViewController: MainViewControllerInputProtocol {
    func reloadData(for sections: [Section]) {
        self.sections = sections
        reloadData()
    }
    
    
}
