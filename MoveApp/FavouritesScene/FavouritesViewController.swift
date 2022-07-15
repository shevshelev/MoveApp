//
//  FavouritesViewController.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

protocol FavouritesViewControllerInputProtocol: AnyObject {
    func reloadData(for sections: [ExpandedSectionViewModel])
}
protocol FavouritesViewControllerOutputProtocol {
    var view: FavouritesViewControllerInputProtocol { get }
    var sections: [ExpandedSectionViewModel] { get }
    init(view: FavouritesViewControllerInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
}

class FavouritesViewController: BaseViewController {
    
    var presenter: FavouritesViewControllerOutputProtocol!
    
    private var sections: [ExpandedSectionViewModel] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(FavouritesHeaderView.self, forHeaderFooterViewReuseIdentifier: FavouritesHeaderView().reuseId)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        presenter = FavouritesPresenter(view: self)
        presenter.viewDidLoad()
    }
}

extension FavouritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(sections[section].isExpanded) {
            return 0
        }
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        cell.backgroundColor = .systemRed
        content.text = movie.title
//        content.secondaryText = 
//        content.textProperties.color = .white
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].type.rawValue
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewModel = sections[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavouritesHeaderView().reuseId) as? FavouritesHeaderView
        header?.viewModel = viewModel
        header?.rotateImage(sections[section].isExpanded)
        header?.delegate = self
        return header
    }
}

extension FavouritesViewController: FavouritesViewControllerInputProtocol {
   
    func reloadData(for sections: [ExpandedSectionViewModel]) {
        self.sections = sections
        tableView.reloadData()
    }
}

extension FavouritesViewController: FavouritesHeaderViewDelegate {
    func expandedSection(number: Int) {
        let isExpanded = sections[number].isExpanded
        sections[number].isExpanded = !(isExpanded)
        tableView.reloadSections(IndexSet(integer: number), with: .automatic)
        
    }
}
