//
//  Weather.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 24.05.2023.
//

import Foundation

struct Weather: Codable {
    let main: Main
    let name: String
}
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

