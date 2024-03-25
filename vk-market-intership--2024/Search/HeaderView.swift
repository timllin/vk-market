//
//  HeaderView.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 25.03.2024.
//

import Foundation
import UIKit


class HeaderView: UIView {
    private lazy var locationIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.image = UIImage(systemName: "location.circle")
        imageView.tintColor = UIColor(named: "DetailColor")
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Location"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(locationIconView)
        addSubview(label)
        NSLayoutConstraint.activate([
            locationIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            locationIconView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: locationIconView.trailingAnchor, constant: 10) ])
    }


}
