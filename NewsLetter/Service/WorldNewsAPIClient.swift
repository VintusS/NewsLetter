//
//  WorldNewsAPIClient.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
//

import Foundation

final class WorldNewsAPIClient {
    var sourceCountry = "md"
    var language = "ro"

    func fetchTopNews() async throws -> Data {
        var components = URLComponents(string: "https://api.worldnewsapi.com/top-news")!
        components.queryItems = [
            URLQueryItem(name: "api-key", value: AppSecrets.worldNewsAPIKey),
            URLQueryItem(name: "source-country", value: sourceCountry),
            URLQueryItem(name: "language", value: language),
        ]

        let url = components.url!
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
