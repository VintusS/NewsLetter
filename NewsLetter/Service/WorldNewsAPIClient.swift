//
//  WorldNewsAPIClient.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
//

import Foundation

struct NewsListItem {
    let title: String
    let summary: String?
}

final class WorldNewsAPIClient {
    var sourceCountry = "md"
    var language = "ro"

    func fetchTopNews() async throws -> [NewsListItem] {
        var components = URLComponents(string: "https://api.worldnewsapi.com/top-news")!
        components.queryItems = [
            URLQueryItem(name: "api-key", value: AppSecrets.worldNewsAPIKey),
            URLQueryItem(name: "source-country", value: sourceCountry),
            URLQueryItem(name: "language", value: language),
        ]

        let url = components.url!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try parseNewsItems(from: data)
    }

    private func parseNewsItems(from data: Data) throws -> [NewsListItem] {
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        guard let dictionary = jsonObject as? [String: Any] else {
            return []
        }

        let newsArray: [[String: Any]]

        if let topNewsClusters = dictionary["top_news"] as? [[String: Any]] {
            newsArray = topNewsClusters.flatMap { cluster in
                (cluster["news"] as? [[String: Any]]) ?? []
            }
        } else {
            newsArray =
                (dictionary["news"] as? [[String: Any]]) ??
                (dictionary["articles"] as? [[String: Any]]) ??
                []
        }

        let items: [NewsListItem] = newsArray.compactMap { article in
            guard let title = article["title"] as? String, !title.isEmpty else {
                return nil
            }

            let summary =
                article["summary"] as? String ??
                article["text"] as? String

            return NewsListItem(title: title, summary: summary)
        }

        return items
    }
}
