//
//  WeatherViewController.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var highestLowestTemp: UILabel!
    
    var cities : Results<City>?
    var weatherDataViewModel = WeatherDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tabBarController?.delegate = self
        self.tabBarController?.selectedIndex = 1

        tableView.register(UINib(nibName: K.Cells.cellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.cellIdentifier)
        tableView.register(UINib(nibName: K.Cells.bigCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.bigCellIdentifier)
        
        //RealmManager.shared.deleteAllFromRealm() if you want to delete all data from Realm
        controlData()
        getData()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
//MARK: - Control the Data from Realm
    func controlData() {
        //for control to understand store the data in realm
        cities = RealmManager.shared.fetchFromRealm()
        //Fetched 209579 cities from Realm
        print("Fetched \(cities?.count) cities from Realm")
    }
    
//MARK: - Get Data
    func getData() {
        self.weatherDataViewModel.fetchData(self.weatherDataViewModel.cityID ?? K.defaultCityID) {
            DispatchQueue.main.async {
                self.cityNameLabel.text = (self.weatherDataViewModel.cityName ?? K.defaultCityName)
                self.currentWeatherLabel.text = self.weatherDataViewModel.currentWeather
                self.feelsLikeLabel.text = self.weatherDataViewModel.feelsLike
                self.descriptionLabel.text = (self.weatherDataViewModel.descp ?? "unknown")
                self.highestLowestTemp.text = self.weatherDataViewModel.highestLowestTemp
                
                self.tableView.reloadData()
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
            if let humidityValue = weatherDataViewModel.humidityValue {
                cell.valueLabel.text = "% \(humidityValue)"
            } else {
                cell.valueLabel.text = "unknown"
            }
            return cell
        } else if (indexPath.item == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.bigCellIdentifier, for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Wind"
            if let windSpeed = weatherDataViewModel.windSpeed {
                cell.valueOneLabel.text = "Speed: \(windSpeed)km/h"
            } else {
                cell.valueOneLabel.text = "Speed: unknown"
            }
            if weatherDataViewModel.windGust != "0" {
                cell.valueTwoLabel.text = "Gust: \(weatherDataViewModel.windGust ?? "0")km/h"
            }else {
                cell.valueTwoLabel.text = "Gust: unknown"
            }
            return cell
        } else if (indexPath.item == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.cellIdentifier, for: indexPath) as! WeatherViewCell
            cell.label.text = "Sea Level"
            if weatherDataViewModel.seaLevel != 0 {
                cell.valueLabel.text = "\(weatherDataViewModel.seaLevel ?? 0)"
            } else {
                cell.valueLabel.text = "unknown"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.bigCellIdentifier, for: indexPath) as! BigWeatherViewCell
            cell.label.text = "Coordinates"
            if let latitude = weatherDataViewModel.coordLat {
                cell.valueOneLabel.text = "Latitude: \(latitude)"
            } else {
                cell.valueOneLabel.text = "Latitude: unknown"
            }
            
            if let longitude = weatherDataViewModel.coordLong {
                cell.valueTwoLabel.text = "Longitude: \(longitude)"
            } else {
                cell.valueTwoLabel.text = "Longitude: unknown"
            }
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

