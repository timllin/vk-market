//
//  APICaller.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 22.03.2024.
//

import Foundation


class APICaller {
    static let shared = APICaller()

    private init() {
    }

    private let baseURL: String = "https://api.open-meteo.com/v1/forecast"

    private var params: [String: String] = ["current": "temperature_2m,relative_humidity_2m,apparent_temperature,cloud_cover,surface_pressure,wind_speed_10m,uv_index",
                                            "daily": "temperature_2m_max,temperature_2m_min",
                                            "forecast_days": "7"]

    public func fetchData(latitude: Double, longitude: Double) async throws -> APIResponse {
        params["latitude"] = String(latitude)
        params["longitude"] = String(longitude)
        guard let url = try? createURLRequest(params: params),
              let (data, response) = try? await URLSession.shared.data(from: url),
              let response = response as? HTTPURLResponse else { throw APICallerError.fetchError }

        guard (200 ... 299) ~= response.statusCode else { throw  APICallerError.badStatusCode}

        do {
            let data = try JSONDecoder().decode(APIResponse.self, from: data)
            return data
        } catch {
            throw APICallerError.decodingError
        }
    }

    private func createURLRequest(params: [String: String]) throws -> URL {
        guard var urlComponents =  URLComponents(string: baseURL) else { fatalError() }
        urlComponents.queryItems = params.map { k, v in URLQueryItem(name: k, value: v) }

        guard let url = urlComponents.url else {
            throw APICallerError.badURL
        }
        return url
    }
}

extension APICaller {
    enum APICallerError: Error {
        case badURL
        case fetchError
        case badStatusCode
        case decodingError
    }
}
