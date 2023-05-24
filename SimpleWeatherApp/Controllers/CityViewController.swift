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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
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
