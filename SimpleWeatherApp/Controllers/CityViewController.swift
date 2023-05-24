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
    var cityIDs: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityNameViewCell", bundle: nil), forCellReuseIdentifier: "CityNameViewCell")
        
        cityNames = cityManager.parseJson().1
        cityIDs = cityManager.parseJson().0
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
