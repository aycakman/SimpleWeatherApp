//
//  City.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import Foundation

struct CityData: Codable {
    let id: Int
    let name: String
}

typealias Cities = [CityData]

