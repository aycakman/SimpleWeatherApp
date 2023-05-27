//
//  CityViewController.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cityManager = CityManager.shared
    var cities = [City]()
    var filteredCity = [City]()
    var selectedRowIndex: Int!
    var cityId: Int64!
    var cityName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: K.Cells.cityCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.cityCellIdentifier)
        
        getData()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.items?[1].image = UIImage(systemName: "\(K.TabBar.tabBarIconSecond).fill")
        filteredCity = cities
        searchBar.text = ""
        tableView.reloadData()
    }
    
//MARK: - Get Data from Core Data
    func getData() {
        DispatchQueue.main.async {
            self.cityManager.checkJsonFile()
            self.cities = self.cityManager.fetchCities()
            self.filteredCity = self.cities
            self.tableView.reloadData()
            //print(cities)
        }
    }
    
//MARK: - Pass Data to First TabBar
    func passDataFromTabBar() {
        if let tabBarController = self.tabBarController, let viewControllers =  tabBarController.viewControllers, let firstTabBarController = viewControllers[0] as? WeatherViewController {
            firstTabBarController.cityID = self.cityId
            firstTabBarController.cityName = self.cityName
        }
    }
}

//MARK: - TableView
extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.cityCellIdentifier, for: indexPath) as! CityNameViewCell
        let city = filteredCity[indexPath.row]
        cell.cityNameLabel.text = city.name
        return cell
    }
}

extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndex = indexPath.row
        cityId = Int64(filteredCity[selectedRowIndex].id)
        cityName = filteredCity[selectedRowIndex].name
        print(cityId!)//checked id
        passDataFromTabBar()
        tabBarController?.tabBar.items?[0].image = UIImage(systemName: "\(K.TabBar.tabBarIconFirst).fill")
        self.tabBarController?.selectedIndex = 0
    }
}

//MARK: - SearchBar
extension CityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCity = []
        if searchText == "" {
            filteredCity = cities
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //the keyboard is dismissed
            }
        }else {
            for city in cities {
                if ((city.name.lowercased().contains(searchText.lowercased())) == true) {
                    filteredCity.append(city)
                }
            }
        }
        tableView.reloadData()
    }
}



