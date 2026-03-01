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
    var onSelectNews: ((NewsListItem) -> Void)?

    let tableView = UITableView(frame: .zero, style: .plain)
    let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Letter"
        setupView()
        setupTableView()
        setupLoadingIndicator()
        activateConstraints()

        Task { [weak self] in
            await self?.loadTopNews()
        }
    }

    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(NewsItemCell.self, forCellReuseIdentifier: Constants.newsCellReuseIdentifier)
        view.addSubview(tableView)
    }

    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    private func activateConstraints() {
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
