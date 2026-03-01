//
//  ViewController.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
//

import UIKit

class ViewController: UIViewController {
    enum Constants {
        static let newsCellReuseIdentifier = "NewsCell"
    }

    let newsClient = WorldNewsAPIClient()
    var newsItems: [NewsListItem] = []

    let tableView = UITableView(frame: .zero, style: .plain)
    let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top News"
        configureUI()

        Task { [weak self] in
            await self?.loadTopNews()
        }
    }

    // MARK: - UI
    private func configureUI() {
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.newsCellReuseIdentifier)
        view.addSubview(tableView)

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // MARK: - News Loading in main thread
    @MainActor
    private func loadTopNews() async {
        do {
            newsItems = try await newsClient.fetchTopNews()
            loadingIndicator.stopAnimating()
            tableView.reloadData()
        } catch {
            loadingIndicator.stopAnimating()
            presentError(error)
        }
    }

    // MARK: - Showing Error Popup
    @MainActor
    private func presentError(_ error: Error) {
        let alert = UIAlertController(
            title: "Failed to Load News",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
