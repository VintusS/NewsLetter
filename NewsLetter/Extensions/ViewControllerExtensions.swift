//
//  ViewControllerExtensions.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
//

import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellReuseIdentifier, for: indexPath)
        let item = newsItems[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.summary
        content.secondaryTextProperties.numberOfLines = 3
        content.textProperties.numberOfLines = 2
        cell.contentConfiguration = content
        cell.selectionStyle = .none

        return cell
    }
}
