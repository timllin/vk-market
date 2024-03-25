//
//  UserDefaultsWorker.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 24.03.2024.
//

import Foundation

struct LocationInfo {
    let latitude: Double
    let longitude: Double
}

class UserDefaultsWorker {
    static let shared = UserDefaultsWorker()

    private static let keyLatitude = "latitude"
    private static let keyLongitude = "longitude"
    private static let city = "city"

    public func saveLocationInfo(locationInfo: LocationInfo) {
        let defaults = UserDefaults.standard
        defaults.set(locationInfo.latitude, forKey: UserDefaultsWorker.keyLatitude)
        defaults.set(locationInfo.longitude, forKey: UserDefaultsWorker.keyLongitude)
    }

    public func getLocationInfo() -> LocationInfo {
        let defaults = UserDefaults.standard
        let latitude = defaults.double(forKey: UserDefaultsWorker.keyLatitude)
        let longitude = defaults.double(forKey: UserDefaultsWorker.keyLongitude)
        return LocationInfo(latitude: latitude, longitude: longitude)
    }

    public func saveCityInfo(city: String) {
        let defaults = UserDefaults.standard
        defaults.set(city, forKey: UserDefaultsWorker.city)
    }

    public func getCityInfo() -> String {
        let defaults = UserDefaults.standard
        let city = defaults.string(forKey: UserDefaultsWorker.city)
        return city ?? ""
    }

}
