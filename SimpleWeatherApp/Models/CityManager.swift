//
//  CityManager.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import Foundation
struct CityManager {

    func readLocalFile(forName fileName: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print("read local file function: \(error)")
        }
        
        return nil
    }
    
    
    func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Cities.self, from: jsonData)
            print("id: ", decodedData[0].id)
        } catch {
            print("parse function: \(error)")
        }
    }
 
}

