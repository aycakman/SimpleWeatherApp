//
//  Constants.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 25.05.2023.
//

import Foundation

struct K {
    static let numberOfRows =  4
    static let defaultCityName = "İstanbul"
    static let cellNibName = "WeatherViewCell"
    static let bigCellNibName = "BigWeatherViewCell"
    static let cityCellNibName = "CityNameViewCell"
    static let cellIdentifier = "WeatherViewCell"
    static let bigCellIdentifier = "BigWeatherViewCell"
    static let cityCellIdentifier = "CityNameViewCell"
    static let jsonFileName = "city.list"
    static let fileType = "json"
    
    struct CoreData {
        static let entityName = "City"
        static let containerName = "SimpleWeatherApp"
    }
}
