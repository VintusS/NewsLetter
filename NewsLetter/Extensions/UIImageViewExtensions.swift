//
//  UIImageViewExtensions.swift
//  NewsLetter
//
//  Created by dragomir.mindrescu on 01.03.2026.
//

import UIKit

extension UIImageView {
    func setNewsImage(from url: URL?) {
        image = UIImage(systemName: "photo")

        guard let url else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
