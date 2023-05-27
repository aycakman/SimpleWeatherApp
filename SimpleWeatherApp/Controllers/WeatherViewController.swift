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
    
    var cities = [City]()
    var weatherData: WeatherData!
    var realmManager = RealmManager.shared
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
        tabBarController?.delegate = self
        
        tableView.register(UINib(nibName: K.Cells.cellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.cellIdentifier)
        tableView.register(UINib(nibName: K.Cells.bigCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.bigCellIdentifier)
        //realmManager.deleteAllFromRealm()

        cities = RealmManager.shared.fetchFromRealm()
        //for control to understand store the data in core data
        print("Fetched \(cities.count) cities from Realm")
      
    }
  
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.fetchData(Int(self.cityID ?? Int64(K.defaultCityID)))
            self.cityNameLabel.text = self.cityName
        }
    }
    
//MARK: - Fetch Data
    func valueForAPIKey(named keyname:String) -> String {
      let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
      let plist = NSDictionary(contentsOfFile:filePath!)
      let value = plist?.object(forKey: keyname) as! String
      return value
    }
    
    func fetchData(_ cityID: Int) {
        guard let url = URL(string: "\(K.API.baseURL)&APPID=\(valueForAPIKey(named: "APIkey"))&id=\(cityID)") else {
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
//MARK: - TableView
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return K.Cells.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.item == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.cellIdentifier, for: indexPath) as! WeatherViewCell
            cell.label.text = "Humidity"
            cell.valueLabel.text = "%" + (humidityValue ?? "0")
            return cell
        }else if (indexPath.item == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.bigCellIdentifier, for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Wind"
            cell.valueOneLabel.text = "Speed: \(windSpeed ?? 0.0)km/h"
            cell.valueTwoLabel.text = "Gust: \(windGust ?? 0.0)km/h"
            return cell
        }else if (indexPath.item == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.cellIdentifier, for: indexPath) as! WeatherViewCell
            cell.label.text = "Sea Level"
            if seaLevel == 0 {
                cell.valueLabel.text = "unknown"
            }else {
                cell.valueLabel.text = "\(seaLevel ?? 0)"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.bigCellIdentifier, for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Coordinates"
            cell.valueOneLabel.text = "Latitude: " + (coordLat ?? "0")
            cell.valueTwoLabel.text = "Longitude: " + (coordLong ?? "0")
            return cell
        }
        
    }
    
}

//MARK: - TabBarController
extension WeatherViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBar = tabBarController.tabBar
        let tabSelectedIndex = [0,1]
        let systemNames = [K.TabBar.tabBarIconFirst, K.TabBar.tabBarIconSecond]
        for index in tabSelectedIndex {
            tabBar.items?[index].image = UIImage(systemName: tabBarController.selectedIndex == index ? "\(systemNames[index]).fill" : systemNames[index])
            
        }
    }
    
}

