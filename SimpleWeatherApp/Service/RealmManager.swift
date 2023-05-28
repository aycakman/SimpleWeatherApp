//
//  RealmManager.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 27.05.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    private init() {}
    
    
    var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        }catch let error {
            print("error initalising realm: \(error)")
            fatalError()
        }
    }
    
    func saveToRealm(cities: Cities) {
        do {
            try realm.write {
                let currentCityID = Set(realm.objects(City.self).map { $0.id })
                cities.forEach { cityData in
                    if !currentCityID.contains(cityData.id) {
                        let city = City()
                        city.id = cityData.id
                        city.name = cityData.name
                        realm.add(city)
                    } else {
                        //print("\(cityData.id) already exists")
                    }
                }
            }
        }catch {
            print("error saving to realm: \(error)")
        }
    }
    
    func deleteAllFromRealm() {
           do {
               try realm.write {
                   realm.deleteAll()
               }
           } catch let error {
               print("Error deleting all data from Realm: \(error)")
           }
       }
    
    func fetchFromRealm() -> [City] {
        let cities = realm.objects(City.self)
        return Array(cities)
        
    }
    
}
