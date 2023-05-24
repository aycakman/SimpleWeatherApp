//
//  CityViewController.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let cityManager = CityManager()
    var cities: [City] = []
    var selectedRowIndex: Int!
    var cityId: Int64!
    var cityName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CityNameViewCell", bundle: nil), forCellReuseIdentifier: "CityNameViewCell")

        DispatchQueue.main.async {
            self.cities = self.cityManager.fetchCities()
            if self.cities.isEmpty {
                self.cityManager.parseAndStoreJson()
                self.cities = self.cityManager.fetchCities()
            }
            self.tableView.reloadData()
        }
     
    }
    
    func passDataFromTabBar() {
        if let tabBarController = self.tabBarController, let viewControllers =  tabBarController.viewControllers, let firstTabBarController = viewControllers[0] as? WeatherViewController {
            firstTabBarController.cityID = self.cityId
            firstTabBarController.cityName = self.cityName
        }
    }
}


extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameViewCell", for: indexPath) as! CityNameViewCell
        let city = cities[indexPath.row]
        cell.cityNameLabel.text = city.name
        return cell
    }
    
    
}
extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndex = indexPath.row
        cityId = cities[selectedRowIndex].id
        cityName = cities[selectedRowIndex].name
        print(cityId!)//checked id
        passDataFromTabBar()
        self.tabBarController?.selectedIndex = 0
    }
}
