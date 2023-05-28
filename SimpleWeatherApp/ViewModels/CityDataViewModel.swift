//
//  CityDataViewModel.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 28.05.2023.
//

import Foundation
import RealmSwift

class CityDataViewModel {
    private let cityManager = CityManager.shared
    private var cities : Results<City>!
    private var filteredCity : Results<City>!
    var cityID: Int!
    var cityName: String!
    
    func getData() {
        cityManager.checkJsonFile()
        cities = cityManager.fetchCities()
        filteredCity = cities
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
        if searchText.isEmpty {
            filteredCity = RealmManager.shared.realm.objects(City.self)
        }else {
            filteredCity = RealmManager.shared.realm.objects(City.self).filter("name CONTAINS[c] %@", searchText).sorted(byKeyPath: "name", ascending: true)
        }
    }
    
    func resetFilterName() {
        filteredCity = cities
    }
    
    func rowsCount() -> Int {
        return filteredCity.count
    }
}
