//
//  CityDataViewModel.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 28.05.2023.
//

import Foundation
class CityDataViewModel {
    private let cityManager = CityManager.shared
    private var cities = [City]()
    private var filteredCity = [City]()
    var cityID: Int!
    var cityName: String!
    
    func getData() {
        cityManager.checkJsonFile()
        self.cities = cityManager.fetchCities()
        self.filteredCity = self.cities
    }
        
    func getCityName(at index: Int) -> City {
        return filteredCity[index]
    }
    
    func selectCityName(at index: Int) {
        cityID = filteredCity[index].id
        cityName = filteredCity[index].name
        print(cityID!) //check ID
    }
    
    func filterCityName(with searchText: String) {
        filteredCity = []
        if searchText.isEmpty {
            filteredCity = cities
        }else {
            filteredCity = searchText.isEmpty ? cities : cities.filter({ $0.name.lowercased().contains(searchText.lowercased()) })//.sorted(by: { $0.name < $1.name})
        }
    }
    
    func resetFilterName() {
        filteredCity = cities
    }
    
    func rowsCount() -> Int {
        return filteredCity.count
    }
}
