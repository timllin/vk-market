//
//  CurrentElementView.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 22.03.2024.
//

import UIKit

class CurrentElementView: UIView {
    let elementType: MainView.CurrentInfoElement

    private lazy var elementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(named: "SecondaryColor")
        return label
    }()

    private lazy var elementDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "SecondaryColor")
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.backgroundColor = UIColor(named: "PrimaryColor")
        return stack
    }()

    private lazy var elementImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = UIColor(named: "DetailColor")
        return image
    }()

    init(frame: CGRect, elementType: MainView.CurrentInfoElement) {
        self.elementType = elementType
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(elementImage)
        stackView.addArrangedSubview(elementLabel)
        stackView.addArrangedSubview(elementDataLabel)
        addSubview(stackView)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true

        NSLayoutConstraint.activate([
            elementImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            elementImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.leadingAnchor.constraint(equalTo: elementImage.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        switch elementType {
        case .wind:
            elementLabel.text = "Wind"
            elementImage.image = UIImage(systemName: "wind")
        case .humidity:
            elementLabel.text = "Humidity"
            elementImage.image = UIImage(systemName: "humidity")
        case .pressure:
            elementLabel.text = "Pressure"
            elementImage.image = UIImage(systemName: "sparkle")
        case .uvIndex:
            elementLabel.text = "UV Index"
            elementImage.image = UIImage(systemName: "sun.max")
        }
    }

    public func configureView(with data: APIResponse.Current) {
        switch elementType {
        case .wind:
            elementDataLabel.text = "\(data.windSpeed10m) km/h"
        case .humidity:
            elementDataLabel.text = "\(data.relativeHumidity2m) %"
        case .pressure:
            elementDataLabel.text = "\(data.surfacePressure) hPa"
        case .uvIndex:
            elementDataLabel.text = "\(data.uvIndex)"
        }
    }
}
