//
//  ViewController.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 22.03.2024.
//

import UIKit

class ViewController: UIViewController {
    let viewModel = MainViewModel()
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(dataPipelineDone), name: .dataPipeline, object: nil)
        viewModel.authLocationManager()
        view = mainView
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocationData()
    }

    private func updateLocationData() {
        self.mainView.startLoading()
        self.viewModel.requestCurrentLocation()
    }

    private func configureView(_ data: APIResponse) {
        self.mainView.configureView(with: data, for: UserDefaultsWorker.shared.getCityInfo())
        mainView.tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.cityButton.addTarget(self, action: #selector(cityButtonTapped), for: .touchUpInside)
    }

    @objc func cityButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        searchVC.modalPresentationStyle = .popover
        self.navigationController?.present(searchVC, animated: true)
    }

    @objc func dataPipelineDone() {
        self.mainView.stopLoading()
        updateUI()
    }
}

extension ViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherData?.daily.time.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell,
              let dirtyDate = viewModel.weatherData?.daily.time[indexPath.row],
              let prettyDate = viewModel.makePrettyDate(data: dirtyDate),
              let lowTemp = viewModel.weatherData?.daily.temperature2mMin[indexPath.row],
              let highTemp = viewModel.weatherData?.daily.temperature2mMax[indexPath.row] else { fatalError() }
        cell.configure(date: prettyDate, lowTemp: lowTemp, highTemp: highTemp)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    @MainActor func updateUI() {
        Task {
            viewModel.weatherData = await viewModel.fetchWeatherData()
            guard let data = viewModel.weatherData else { return }
            self.configureView(data)
            self.mainView.tableView.reloadData()
        }
    }
}

extension ViewController: SearchViewControllerOutput {
    func searchWasEnded() {
        viewModel.updateWeatherLocation()
        updateUI()
    }

    func searchCurrentLocation() {
        updateLocationData()
    }
}
