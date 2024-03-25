//
//  ForecastCell.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 24.03.2024.
//

import UIKit

class ForecastCell: UITableViewCell {
    static let identifier = "ForecastCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dateStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()

    private lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Consts.weekday)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Consts.date)
        label.textColor = Consts.descriptionColor
        return label
    }()

    private lazy var tempStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()

    private lazy var lowTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Consts.temperature)
        label.textColor = Consts.descriptionColor
        return label
    }()

    private lazy var highTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Consts.temperature)
        return label
    }()

    private func setupCell() {
        dateStack.addArrangedSubview(weekdayLabel)
        dateStack.addArrangedSubview(dateLabel)
        addSubview(dateStack)
        tempStack.addArrangedSubview(lowTempLabel)
        tempStack.addArrangedSubview(highTempLabel)
        addSubview(tempStack)

        NSLayoutConstraint.activate([
            dateStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            tempStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tempStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

    }

    public func configure(date: (String, String), lowTemp: Double, highTemp: Double) {
        dateLabel.text = date.0
        weekdayLabel.text = date.1
        lowTempLabel.text =  String(format: "%.0f", lowTemp)
        highTempLabel.text =  String(format: "%.0f", highTemp)
    }
}

extension ForecastCell {
    struct Consts {
        static let weekday: CGFloat = 14
        static let date: CGFloat = 12
        static let temperature: CGFloat = 14
        static let descriptionColor: UIColor = .gray
    }
}
