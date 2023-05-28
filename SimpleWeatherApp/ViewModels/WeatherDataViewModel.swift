//
//  WeatherDataViewModel.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 28.05.2023.
//

import Foundation

class WeatherDataViewModel {
    
    var currentWeather: String!
    var feelsLike: String!
    var highestLowestTemp: String!
    var humidityValue: String!
    var windSpeed: String!
    var windGust: String?
    var coordLat: String!
    var coordLong: String!
    var seaLevel: Int?
    var descp: String!
    var cityID: Int!
    var cityName: String!
    var networkService = NetworkService.shared

    func valueForAPIKey(named keyname:String) -> String {
      let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
      let plist = NSDictionary(contentsOfFile:filePath!)
      let value = plist?.object(forKey: keyname) as! String
      return value
    }
    
    func fetchData(_ cityID: Int, completion: @escaping() -> Void) {
        guard let url = URL(string: "\(K.API.baseURL)&APPID=\(valueForAPIKey(named: "APIkey"))&id=\(cityID)") else {
            print("invalid URL")
            return
        }
        networkService.downloadData(url: url) { (weather: WeatherData?) in
             if let weather = weather {
                 self.currentWeather = "Current: \(String(format: "%.0f", weather.main.temp))°C"
                 self.feelsLike = "Feels like: \(String(format: "%.0f", weather.main.feelsLike))°C"
                 self.humidityValue = String(format: "%.0f", weather.main.humidity)
                 self.windSpeed = String(format: "%.0f", weather.wind.speed)
                 self.windGust = String(format: "%.0f", weather.wind.gust ?? 0)
                 self.coordLat = String(format: "%.0f", weather.coord.lat)
                 self.coordLong = String(format: "%.0f", weather.coord.lon)
                 self.seaLevel = Int(weather.main.seaLevel ?? 0)
                 self.highestLowestTemp = "H: \(String(format: "%.0f",weather.main.tempMax))°C  L: \(String(format: "%.0f", weather.main.tempMin))°C"
                 
                 for w in weather.weather{
                     self.descp = w.description
                     self.descp = "Today's Weather Description: " + (self.descp ?? "unknown")
                 }
                 print("data: \(weather)") //to control the data
                 completion()
             }
         }
    }
    
}
