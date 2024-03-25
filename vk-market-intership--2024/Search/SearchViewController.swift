//
//  SearchViewController.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 24.03.2024.
//

import UIKit
import MapKit

protocol SearchViewControllerOutput: AnyObject {
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
        field.font = UIFont.systemFont(ofSize: 14)
        field.placeholder = "Search for a city"
        field.textColor = UIColor(named: "SecondaryColor")
        field.delegate = self
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        completer.delegate = self
        completer.region = MKCoordinateRegion(.world)
        completer.pointOfInterestFilter = .excludingAll
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.searchWasEnded()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryColor")
        view.addSubview(searchField)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            searchField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = cityResults[indexPath.row]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = item.createQuery()
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {return}
            let coordinate = response.boundingRegion.center

            guard let latitude = coordinate.latitude as? Double,
                  let longitude = coordinate.longitude as? Double else { return }
            let weatherLocation = LocationInfo(latitude: latitude, longitude: longitude)
            UserDefaultsWorker.shared.saveLocationInfo(locationInfo: weatherLocation)
            UserDefaultsWorker.shared.saveCityInfo(city: item.title)
            self.dismiss(animated: true)
        }
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completionResults = completer.results
        completionResults = completionResults.filter({ (result) -> Bool in return result.title != "" && !result.subtitle.contains("найти") })
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
