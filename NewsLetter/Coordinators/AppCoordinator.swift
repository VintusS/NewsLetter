//
//  AppCoordinator.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
//

import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let newsListViewController = ViewController()
        newsListViewController.onSelectNews = { [weak self] newsItem in
            self?.showDetails(for: newsItem)
        }

        navigationController.setViewControllers([newsListViewController], animated: false)
    }

    private func showDetails(for newsItem: NewsListItem) {
        let detailViewController = NewsDetailViewController(newsItem: newsItem)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
