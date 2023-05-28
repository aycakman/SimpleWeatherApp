//
//  Weather.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 24.05.2023.
//

import Foundation
//FFE381
struct WeatherData: Codable {
    let coord: Coord
    let main: Main
    let name: String
    let weather: [Weather]
    let wind: Wind
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let seaLevel : Int?
    let pressure, humidity: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case pressure, humidity
    }
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
