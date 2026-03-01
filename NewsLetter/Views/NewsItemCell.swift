//
//  NewsItemCell.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.image = UIImage(systemName: "photo")
        titleLabel.text = nil
        summaryLabel.text = nil
    }

    func configure(with item: NewsListItem) {
        titleLabel.text = item.title
        summaryLabel.text = item.summary
        articleImageView.setNewsImage(from: item.imageURL)
    }

    // MARK: - UI Configuration
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
}
