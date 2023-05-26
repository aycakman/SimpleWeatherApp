//
//  CityManager.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import Foundation
struct CityManager {
    
    static let shared = CityManager()
    private init() {}
    
    let coreDataManager = CoreDataManager.shared

    func parseAndStoreJson() {
        if let path = Bundle.main.path(forResource: K.jsonFileName, ofType: K.fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let citiesData = try decoder.decode(Cities.self, from: data)
                coreDataManager.saveToCoreData(cities: citiesData)
            } catch {
                print("Error parsing and storing the json file: \(error)")
            }
        }
    }

    func fetchCities() -> [City] {
        return coreDataManager.fetchFromCoreData()
    }
}


