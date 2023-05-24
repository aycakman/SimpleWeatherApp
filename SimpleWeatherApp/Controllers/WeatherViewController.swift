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
    
    var cities : [City] = []
    var weatherData: WeatherData!
    var cityID : Int64!
    var cityName: String!
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
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "WeatherViewCell", bundle: nil), forCellReuseIdentifier: "WeatherViewCell")
        tableView.register(UINib(nibName: "BigWeatherViewCell", bundle: nil), forCellReuseIdentifier: "BigWeatherViewCell")
        
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

    func fetchData(_ cityID: Int) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?APPID=4a14f952b89bd72d7395a61a3c053f93&units=metric&id=\(cityID)") else {
            print("invalid URL")
            return
        }
        NetworkService().downloadData(url: url) { [weak self] (weather: WeatherData?) in
             if let weather = weather {
                 self?.currentWeatherLabel.text = "Current: \(String(format: "%.0f", weather.main.temp))"
                 self?.feelsLikeLabel.text = "Feels like: \(String(format: "%.0f", weather.main.feelsLike))"
                 self?.humidityValue = String(format: "%.0f", weather.main.humidity)
                 self?.windSpeed = weather.wind.speed
                 self?.windGust = weather.wind.gust
                 self?.coordLat = String(format: "%.0f", weather.coord.lat)
                 self?.coordLong = String(format: "%.0f", weather.coord.lon)
                 self?.seaLevel = Int(weather.main.seaLevel ?? 0)
                 for w in weather.weather{
                     self?.descp = w.description
                     self?.descriptionLabel.text = self?.descp
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.item == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherViewCell", for: indexPath) as! WeatherViewCell
            cell.label.text = "Humidity"
            cell.valueLabel.text = "%" + (humidityValue ?? "0")
            return cell
        }else if (indexPath.item == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigWeatherViewCell", for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Wind"
            cell.valueOneLabel.text = "Speed: \(windSpeed ?? 0.0)km/h"
            cell.valueTwoLabel.text = "Gust: \(windGust ?? 0.0)km/h"
            return cell
        }else if (indexPath.item == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherViewCell", for: indexPath) as! WeatherViewCell
            cell.label.text = "Sea Level"
            cell.valueLabel.text = "\(seaLevel ?? 0)"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigWeatherViewCell", for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Coordinates"
            cell.valueOneLabel.text = "Latitude: " + (coordLat ?? "0")
            cell.valueTwoLabel.text = "Longitude: " + (coordLong ?? "0")
            return cell
        }
        
    }

    
    
}
