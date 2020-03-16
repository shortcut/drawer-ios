//
//  SearchDrawerViewController.swift
//  Maps
//
//  Created by Denis Dzyubenko on 16/03/2020.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import UIKit

class SearchDrawerViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    enum Section: Int, CaseIterable {
        case favorites
        case recent
    }

    typealias RecentLocation = (color: UIColor, title: String, subtitle: String)
    let recent: [RecentLocation] = [
        (color: UIColor.systemTeal, title: "Fageråsen 1234", subtitle: "Trysil"),
        (color: UIColor.systemTeal, title: "Oslo", subtitle: "Norway"),
        (color: UIColor.systemTeal, title: "Moscow", subtitle: "Russia"),
        (color: UIColor.systemTeal, title: "San Francisco", subtitle: "USA"),
    ]

    func resignSearchFocus() {
        searchBar.resignFirstResponder()
    }
}

extension SearchDrawerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .favorites:
            return 1
        case .recent:
            return recent.count
        case .none:
            assertionFailure()
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .favorites:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
            return cell
        case .recent:
            let location = recent[indexPath.row]
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecentCell", for: indexPath) as! SearchRecentLocationCell
            cell.iconColor = location.color
            cell.title = location.title
            cell.subtitle = location.subtitle
            return cell
        case .none:
            assertionFailure()
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .favorites:
            return "Favorites"
        case .recent:
            return "Recently viewed"
        case .none:
            assertionFailure()
            return nil
        }
    }
}

extension SearchDrawerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
