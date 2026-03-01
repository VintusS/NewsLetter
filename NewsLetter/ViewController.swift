//
//  ViewController.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
//

import UIKit

class ViewController: UIViewController {
    private let newsClient = WorldNewsAPIClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task { [weak self] in
            await self?.loadTopNews()
        }
    }

    @MainActor
    private func loadTopNews() async {
        do {
            let data = try await newsClient.fetchTopNews()
            let responseText = String(data: data, encoding: .utf8) ?? "Could not decode response"
            print(responseText)
        } catch {
            print("Request failed: \(error.localizedDescription)")
        }
    }
}
