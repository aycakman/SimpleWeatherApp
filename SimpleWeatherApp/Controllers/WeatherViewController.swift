//
//  WeatherViewController.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "WeatherViewCell", bundle: nil), forCellReuseIdentifier: "WeatherViewCell")
        tableView.register(UINib(nibName: "BigWeatherViewCell", bundle: nil), forCellReuseIdentifier: "BigWeatherViewCell")
        
        let cities = CoreDataManager.shared.fetchFromCoreData()
        //for control to understand store the data in core data
        //Fetched 68154 cities from CoreData
        print("Fetched \(cities.count) cities from CoreData")
        for city in cities {
            print("City Name: \(city.name ?? ""), City ID: \(city.id)")
        }
    }

}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.item % 2 == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherViewCell", for: indexPath) as! WeatherViewCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigWeatherViewCell", for: indexPath) as! BigWeatherViewCell
            return cell
        }
   
    }
    
    
}
