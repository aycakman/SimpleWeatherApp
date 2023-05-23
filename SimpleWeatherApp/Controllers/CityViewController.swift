//
//  CityViewController.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cityManager = CityManager()
    var cityNames: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityNameViewCell", bundle: nil), forCellReuseIdentifier: "CityNameViewCell")
        // Do any additional setup after loading the view.
//        if let localData = cityManager.readLocalFile(forName: "city.list") {
//            cityManager.parse(jsonData: localData)
//        }
        
        cityNames = parseJson()
        print(cityNames)
    }
    
    func parseJson() -> [String] {
        var cityNames = [String]()
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let cities = try decoder.decode([City].self, from: data)
                cityNames = cities.map { $0.name }
                
            } catch {
                print("fetch the name in json file: \(error)")
            }
        }
        return cityNames
    }
}

extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameViewCell", for: indexPath) as! CityNameViewCell
        cell.cityNameLabel.text = cityNames[indexPath.row]
        return cell
    }
    
    
    
}
