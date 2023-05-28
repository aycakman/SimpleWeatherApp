//
//  CityManager.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import Foundation
import Gzip
import RealmSwift

struct CityManager {
    
    static let shared = CityManager()
    private init() {}

    let realmManager = RealmManager.shared
    
    func checkJsonFile() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentDirectory.appendingPathComponent(K.jsonFileName)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            print("Prevent to download the json file again.")
            parseAndStoreJson()
        } else {
            downloadJsonFile()
        }
    }
    
    func downloadJsonFile() {
        let url = URL(string: K.jsonFileUrl)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading the json file : \(error)")
            }else if let data = data {
                print("saved!")
                self.saveJsonFile(data: data)
                self.parseAndStoreJson()
            }
        }
        task.resume()
    }
    
    func saveJsonFile(data: Data) {
        guard let decompressedFile  = try? data.gunzipped() else {
            print("Failed to decompressed process")
            return
        }
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(K.jsonFileName)
        
        do {
            try decompressedFile.write(to: fileURL)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("Json file saved: \(fileURL)")
            } else {
                print("Json file not saved.")
            }
        }catch {
            print("Error saving the json file: \(error)")
        }
        
    }
    
    func parseAndStoreJson() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentDirectory.appendingPathComponent(K.jsonFileName)
        
        if !realmManager.fetchFromRealm().isEmpty {
            print("Prevent to parse json file again")
        }
        do {
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let citiesData = try decoder.decode(Cities.self, from: data)
            realmManager.saveToRealm(cities: citiesData)
        } catch {
            print("Error parsing and storing the json file: \(error)")
        }
        
    }

    func fetchCities() -> Results<City> {
        return realmManager.realm.objects(City.self)
    }
    
}


