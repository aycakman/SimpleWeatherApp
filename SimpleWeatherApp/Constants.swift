//
//  Constants.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 25.05.2023.
//

import Foundation

struct K {
    static let defaultCityName = "İstanbul"
    static let defaultCityID = 745044
    static let jsonFileName = "city.list"
    static let fileType = "json"
    static let jsonFileUrl = "https://bulk.openweathermap.org/sample/city.list.json.gz"
    
    struct Cells {
        static let numberOfRows =  4
        static let cellNibName = "WeatherViewCell"
        static let bigCellNibName = "BigWeatherViewCell"
        static let cityCellNibName = "CityNameViewCell"
        static let cellIdentifier = "WeatherViewCell"
        static let bigCellIdentifier = "BigWeatherViewCell"
        static let cityCellIdentifier = "CityNameViewCell"
    }

    struct CoreData {
        static let entityName = "City"
        static let containerName = "SimpleWeatherApp"
    }
    
    struct TabBar {
        static let tabBarIconFirst = "cloud"
        static let tabBarIconSecond = "location"
    }
    
    struct API {
        static let baseURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric"
    }
     
}
