//
//  SearchViewController.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 24.03.2024.
//

import UIKit
import MapKit

protocol SearchViewControllerOutput: AnyObject {
    func searchCurrentLocation()
    func searchWasEnded()

}

class SearchViewController: UIViewController {
    weak var delegate: SearchViewControllerOutput?
    var completer = MKLocalSearchCompleter()
    var completionResults: [MKLocalSearchCompletion] = []

    var cityResults: [SearchInfo] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(named: "PrimaryColor")
        return tableView
    }()

    private lazy var searchField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 35).isActive = true
        field.font = UIFont.systemFont(ofSize: 14)
        field.placeholder = "Search for a city"
        field.textColor = UIColor(named: "SecondaryColor")
        field.delegate = self
        field.layer.cornerRadius = 8
        field.backgroundColor = .systemGray5
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 35))
        field.leftViewMode = .always
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        completer.delegate = self
        completer.region = MKCoordinateRegion(.world)
        completer.pointOfInterestFilter = .excludingAll
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryColor")
        view.addSubview(searchField)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            searchField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }

}

extension SearchViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        completer.queryFragment = text
    }

    @objc func headerTap() {
        delegate?.searchCurrentLocation()
        dismiss(animated: true)
    }
}

extension SearchViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { fatalError() }
        cell.textLabel?.text = cityResults[indexPath.row].createQuery()
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = UIColor(named: "PrimaryColor")
        cell.textLabel?.textColor = UIColor(named: "SecondaryColor")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerTap))
        headerView.addGestureRecognizer(tapRecognizer)
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = cityResults[indexPath.row]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = item.createQuery()
        let search = MKLocalSearch(request: request)
        search.start {[weak self] (response, error) in
            guard let response = response else {return}
            let coordinate = response.boundingRegion.center

            guard let self = self else { return }
            let weatherLocation = LocationInfo(latitude: coordinate.latitude, longitude: coordinate.longitude)
            UserDefaultsWorker.shared.saveLocationInfo(locationInfo: weatherLocation)
            UserDefaultsWorker.shared.saveCityInfo(city: item.title)
            self.delegate?.searchWasEnded()
            self.dismiss(animated: true)
        }
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completionResults = completer.results
        completionResults = completionResults.filter({ (result) -> Bool in return result.title != "" && !result.subtitle.contains("найти")  && !result.subtitle.contains("Search")})
        if completionResults.count > 0 {
           var newResults: [SearchInfo] = []
           for result in completionResults {
               newResults.append(SearchInfo(title: result.title, subtitle: result.subtitle))
           }
           if newResults.count > 0 {
               cityResults = newResults
           }
       }
    }
}
