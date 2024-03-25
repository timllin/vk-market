//
//  MainView.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 22.03.2024.
//

import UIKit

class MainView: UIScrollView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalToConstant: 308).isActive = true
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = Consts.primaryColor
        
        return tableView
    }()

    lazy var cityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Consts.cityFont)
        button.setTitleColor(Consts.secondaryColor, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.configuration?.imagePadding = 2
        button.tintColor = Consts.descriptionColor
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.font = UIFont.boldSystemFont(ofSize: Consts.titleFont)
        label.textColor = Consts.secondaryColor
        return label
    }()

    private lazy var feelsLikeTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        label.textColor = Consts.descriptionColor
        return label
    }()

    private lazy var currentlyInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()

    private lazy var currentlyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        label.text = "Currently"
        label.font = UIFont.boldSystemFont(ofSize: Consts.description)
        label.textColor = Consts.secondaryColor
        return label
    }()

    private lazy var forecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        label.text = "7-day forecast"
        label.font = UIFont.boldSystemFont(ofSize: Consts.description)
        label.textColor = Consts.secondaryColor
        return label
    }()

    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = Consts.descriptionColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Consts.primaryColor
        bounces = false
        showsVerticalScrollIndicator = false
        addSubview(cityButton)
        addSubview(currentTempLabel)
        addSubview(feelsLikeTempLabel)
        addSubview(currentlyLabel)
        CurrentInfoElement.allCases.forEach {
            currentlyInfoStack.addArrangedSubview(CurrentElementView(frame: .zero, elementType: $0))
        }
        addSubview(currentlyInfoStack)
        addSubview(separator)
        addSubview(forecastLabel)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            cityButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cityButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            cityButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),

            currentTempLabel.topAnchor.constraint(equalTo: cityButton.bottomAnchor, constant: 25),
            currentTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            feelsLikeTempLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 12),
            feelsLikeTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            currentlyLabel.topAnchor.constraint(equalTo: feelsLikeTempLabel.bottomAnchor, constant: 32),
            currentlyLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),

            currentlyInfoStack.topAnchor.constraint(equalTo: currentlyLabel.bottomAnchor, constant: 8),
            currentlyInfoStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            currentlyInfoStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),

            separator.topAnchor.constraint(equalTo: currentlyInfoStack.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),

            forecastLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8),
            forecastLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),

            tableView.topAnchor.constraint(equalTo: forecastLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }

    public func configureView(with data: APIResponse, for city: String) {
        cityButton.setTitle(city, for: .normal)
        currentTempLabel.text = makeCelcuis(data.current.temperature2m) //String(format: "%.0f", data.current.temperature2m)
        feelsLikeTempLabel.text = "Feels like " + makeCelcuis(data.current.apparentTemperature)//String(format: "%.0f", data.current.apparentTemperature)
        for subview in currentlyInfoStack.arrangedSubviews {
            guard let subview = subview as? CurrentElementView else { return }
            subview.configureView(with: data.current)
        }

    }
}

extension MainView {
    enum CurrentInfoElement: CaseIterable {
        case wind
        case humidity
        case pressure
        case uvIndex
    }

    struct Consts {
        static let cityFont: CGFloat = 16
        static let titleFont: CGFloat = 40
        static let description: CGFloat = 14
        static let primaryColor = UIColor(named: "PrimaryColor")
        static let secondaryColor = UIColor(named: "SecondaryColor")
        static let descriptionColor = UIColor(named: "DescriptionColor")
        static let detailColor = UIColor(named: "DetailColor")
    }

    private func makeCelcuis(_ data: Double) -> String {
        let measurment = Measurement(value: data, unit: UnitTemperature.celsius)
        let measurmentFormatter = MeasurementFormatter()
        measurmentFormatter.unitStyle = .short
        measurmentFormatter.numberFormatter.maximumFractionDigits = 0
        measurmentFormatter.unitOptions = .temperatureWithoutUnit
        return measurmentFormatter.string(from: measurment)
    }
}
