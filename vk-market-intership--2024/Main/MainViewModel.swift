//
//  MainViewModel.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 22.03.2024.
//

import Foundation
import CoreLocation
import MapKit

class MainViewModel: NSObject {
    var weatherData: APIResponse?
    var weatherLocation: LocationInfo
    let locationManager: CLLocationManager

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        self.weatherLocation = UserDefaultsWorker.shared.getLocationInfo()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.showsBackgroundLocationIndicator = true
    }

    public func authLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    public func requestCurrentLocation()  {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        case .denied, .restricted:
            UserDefaultsWorker.shared.saveLocationInfo(locationInfo: LocationInfo(latitude: 00, longitude: 00))
        default:
            authLocationManager()
            break
        }
    }

    public func fetchWeatherData() async -> APIResponse? {
        weatherData = try? await APICaller.shared.fetchData(latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        return weatherData
    }

}

//MARK: Location Manager
extension MainViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .denied, .restricted:
            print(manager.authorizationStatus.rawValue)
            requestCurrentLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude as? Double,
              let longitude = locations.last?.coordinate.longitude as? Double else { return }

        self.weatherLocation = LocationInfo(latitude: latitude, longitude: longitude)
        UserDefaultsWorker.shared.saveLocationInfo(locationInfo: self.weatherLocation )
        getLocationCity()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }


    func getLocationCity(locationInfo: LocationInfo = UserDefaultsWorker.shared.getLocationInfo())  {
        let location = CLLocation(latitude: CLLocationDegrees(floatLiteral: locationInfo.latitude), longitude: CLLocationDegrees(floatLiteral: locationInfo.longitude))
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
             if let city = placemarks?.first?.locality {
                UserDefaultsWorker.shared.saveCityInfo(city: city)
                NotificationCenter.default.post(name: .dataPipeline, object: nil)
            }
        })
    }
}

//MARK: Data Prep
extension MainViewModel {
    public func makePrettyDate(data: String) -> (String, String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let transformDate = dateFormatter.date(from: data) else { return nil }

        dateFormatter.dateFormat = "MMM dd"
        let prettyDate = dateFormatter.string(from: transformDate)

        dateFormatter.dateFormat = "EEEE"
        let weekdayDate = dateFormatter.string(from: transformDate)
        return (prettyDate, weekdayDate)
    }

    public func updateWeatherLocation() {
        self.weatherLocation = UserDefaultsWorker.shared.getLocationInfo()
    }
}

extension Notification.Name {
    static let dataPipeline = Notification.Name("dataPipeline")
}
