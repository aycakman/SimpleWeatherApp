//
//  WeatherViewController.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var highestLowestTemp: UILabel!
    
    var cities : [City] = []
    var weatherData: WeatherData!
    var cityID : Int64!
    var cityName: String = K.defaultCityName
    var humidityValue: String!
    var windSpeed: Double!
    var windGust: Double!
    var coordLat: String!
    var coordLong: String!
    var seaLevel: Int?
    var descp: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.register(UINib(nibName: K.bigCellNibName, bundle: nil), forCellReuseIdentifier: K.bigCellIdentifier)
        
        cities = CoreDataManager.shared.fetchFromCoreData()
        //for control to understand store the data in core data
        //Fetched 68154 cities from CoreData
        print("Fetched \(cities.count) cities from CoreData")
//        for city in cities {
//            print("City Name: \(city.name ?? ""), City ID: \(city.id)")
//        }
      
    }
  
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.fetchData(Int(self.cityID ?? 745044))
            self.cityNameLabel.text = self.cityName
        }
    }

    func valueForAPIKey(named keyname:String) -> String {
      let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
      let plist = NSDictionary(contentsOfFile:filePath!)
      let value = plist?.object(forKey: keyname) as! String
      return value
    }
    
    func fetchData(_ cityID: Int) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?APPID=\(valueForAPIKey(named: "APIkey"))&units=metric&id=\(cityID)") else {
            print("invalid URL")
            return
        }
        NetworkService().downloadData(url: url) { [weak self] (weather: WeatherData?) in
             if let weather = weather {
                 self?.currentWeatherLabel.text = "Current: \(String(format: "%.0f", weather.main.temp))°C"
                 self?.feelsLikeLabel.text = "Feels like: \(String(format: "%.0f", weather.main.feelsLike))°C"
                 self?.humidityValue = String(format: "%.0f", weather.main.humidity)
                 self?.windSpeed = weather.wind.speed
                 self?.windGust = weather.wind.gust
                 self?.coordLat = String(format: "%.0f", weather.coord.lat)
                 self?.coordLong = String(format: "%.0f", weather.coord.lon)
                 self?.seaLevel = Int(weather.main.seaLevel ?? 0)
                 self?.highestLowestTemp.text = "H: \(String(format: "%.0f",weather.main.tempMax))°C  L: \(String(format: "%.0f", weather.main.tempMin))°C"
                 
                 for w in weather.weather{
                     self?.descp = w.description
                     self?.descriptionLabel.text = "Today's Weather Description: " + (self?.descp ?? "none")
                 }
                 print(weather) //check the data
                 DispatchQueue.main.async {
                     self?.tableView.reloadData()
                 }
             }
         }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return K.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.item == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! WeatherViewCell
            cell.label.text = "Humidity"
            cell.valueLabel.text = "%" + (humidityValue ?? "0")
            return cell
        }else if (indexPath.item == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: K.bigCellIdentifier, for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Wind"
            cell.valueOneLabel.text = "Speed: \(windSpeed ?? 0.0)km/h"
            cell.valueTwoLabel.text = "Gust: \(windGust ?? 0.0)km/h"
            return cell
        }else if (indexPath.item == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! WeatherViewCell
            cell.label.text = "Sea Level"
            if seaLevel == 0 {
                cell.valueLabel.text = "unknown"
            }else {
                cell.valueLabel.text = "\(seaLevel ?? 0)"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.bigCellIdentifier, for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Coordinates"
            cell.valueOneLabel.text = "Latitude: " + (coordLat ?? "0")
            cell.valueTwoLabel.text = "Longitude: " + (coordLong ?? "0")
            return cell
        }
        
    }

    
    
}
