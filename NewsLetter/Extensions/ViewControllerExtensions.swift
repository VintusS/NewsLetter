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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.newsCellReuseIdentifier,
            for: indexPath
        ) as? NewsItemCell else {
            return UITableViewCell()
        }

        let item = newsItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}
