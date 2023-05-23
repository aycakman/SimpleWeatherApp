//
//  City.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import Foundation

struct City: Codable {
    let id: Int
    let name, state: String
    let country: String
    let coord: Coord
}

struct Coord: Codable {
    let lon, lat: Double
}

typealias Cities = [City]

