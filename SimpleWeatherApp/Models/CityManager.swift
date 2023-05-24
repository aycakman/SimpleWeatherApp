//
//  CityManager.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import Foundation
struct CityManager {
    
    func parseJson() -> ([Int], [String]){
        var cityID = [Int]()
        var cityName = [String]()
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let cities = try decoder.decode(Cities.self, from: data)
                cityID = cities.map { $0.id }
                cityName = cities.map { $0.name }

            } catch {
                print("fetch the name in json file: \(error)")
            }
        }
        return (cityID, cityName)
    }
}

