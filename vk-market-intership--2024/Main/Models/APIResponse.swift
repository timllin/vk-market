//
//  APIResponse.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 22.03.2024.
//

import Foundation

struct APIResponse: Codable {
    let current: Current
    let daily: Daily

    struct Current: Codable {
        let time: String
        let temperature2m: Double
        let relativeHumidity2m: Double
        let surfacePressure: Double
        let windSpeed10m: Double
        let apparentTemperature: Double
        let uvIndex: Double

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
            case relativeHumidity2m = "relative_humidity_2m"
            case surfacePressure = "surface_pressure"
            case windSpeed10m = "wind_speed_10m"
            case apparentTemperature = "apparent_temperature"
            case uvIndex = "uv_index"
        }
    }

    struct Daily: Codable {
        let time: [String]
        let temperature2mMax: [Double]
        let temperature2mMin: [Double]

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2mMax = "temperature_2m_max"
            case temperature2mMin = "temperature_2m_min"
        }
    }
}

