//
//  CityManager.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import Foundation
import Gzip

struct CityManager {
    
    static let shared = CityManager()
    private init() {}

    let coreDataManager = CoreDataManager.shared

    func downloadJsonFile() {
        let url = URL(string: K.jsonFileUrl)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("downloading json: \(error)")
            }else if let data = data {
                print("saved!")
                self.saveJsonFile(data: data)
            }
        }
        task.resume()
    }
    
    func saveJsonFile(data: Data) {
        guard let decompressedFile  = try? data.gunzipped() else {
            print("failed to decompressed process")
            return
        }
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("city.list.json")
        
        do {
            try decompressedFile.write(to: fileURL)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("file saved: \(fileURL)")
            } else {
                print("file not saved")
            }
        }catch {
            print("error saving file: \(error)")
        }
        
    }
    
    func parseAndStoreJson() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentDirectory.appendingPathComponent("city.list.json")
        do {
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let citiesData = try decoder.decode(Cities.self, from: data)
            coreDataManager.saveToCoreData(cities: citiesData)
        } catch {
            print("Error parsing and storing the json file: \(error)")
        }
        
    }

    func fetchCities() -> [City] {
        return coreDataManager.fetchFromCoreData()
    }
}


