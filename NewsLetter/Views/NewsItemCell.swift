//
//  NewsItemCell.swift
//  NewsLetter
//
//  Created by Codex on 01.03.2026.
//

import UIKit

final class NewsItemCell: UITableViewCell {
    private enum Constants {
        static let imageSize: CGFloat = 88
        static let padding: CGFloat = 12
        static let cornerRadius: CGFloat = 12
    }

    private let articleImageView = UIImageView()
    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private let textStack = UIStackView()
    private let contentStack = UIStackView()
    private var imageTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        articleImageView.image = UIImage(systemName: "photo")
        titleLabel.text = nil
        summaryLabel.text = nil
    }

    func configure(with item: NewsListItem) {
        titleLabel.text = item.title
        summaryLabel.text = item.summary
        loadImage(from: item.imageURL)
    }

    private func setupUI() {
        selectionStyle = .none

        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = Constants.cornerRadius
        articleImageView.tintColor = .secondaryLabel
        articleImageView.backgroundColor = .secondarySystemBackground
        articleImageView.image = UIImage(systemName: "photo")

        titleLabel.numberOfLines = 2
        titleLabel.font = .preferredFont(forTextStyle: .headline)

        summaryLabel.numberOfLines = 3
        summaryLabel.font = .preferredFont(forTextStyle: .subheadline)
        summaryLabel.textColor = .secondaryLabel

        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(summaryLabel)

        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.spacing = Constants.padding
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(articleImageView)
        contentStack.addArrangedSubview(textStack)

        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            articleImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            articleImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),

            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
        ])
    }

    private func loadImage(from url: URL?) {
        imageTask?.cancel()
        imageTask = nil
        articleImageView.image = UIImage(systemName: "photo")

        guard let url else {
            return
        }

        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self,
                let data,
                let image = UIImage(data: data)
            else {
                return
            }

            DispatchQueue.main.async {
                self.articleImageView.image = image
            }
        }

        imageTask?.resume()
    }
}
