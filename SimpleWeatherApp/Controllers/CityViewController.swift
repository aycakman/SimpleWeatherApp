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
    
    var cityDataViewModel = CityDataViewModel()

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
        searchBar.text = ""
        cityDataViewModel.resetFilterName()
        tableView.reloadData()
    }
    
//MARK: - Get Data
    func getData() {
        self.cityDataViewModel.getData()
        self.tableView.reloadData()
    }
    
//MARK: - Pass Data to First TabBar
    func passDataFromTabBar() {
        if let tabBarController = self.tabBarController, let viewControllers =  tabBarController.viewControllers, let firstTabBarController = viewControllers[0] as? WeatherViewController {
            firstTabBarController.weatherDataViewModel.cityID = self.cityDataViewModel.cityID
            firstTabBarController.weatherDataViewModel.cityName = self.cityDataViewModel.cityName
        }
    }
}

//MARK: - TableView
extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityDataViewModel.rowsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.cityCellIdentifier, for: indexPath) as! CityNameViewCell
        let city = cityDataViewModel.getCityName(at: indexPath.row)
        cell.cityNameLabel.text = city.name
        return cell
    }
}

extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityDataViewModel.selectCityName(at: indexPath.row)
        passDataFromTabBar()
        tabBarController?.tabBar.items?[0].image = UIImage(systemName: "\(K.TabBar.tabBarIconFirst).fill")
        self.tabBarController?.selectedIndex = 0
    }
}

//MARK: - SearchBar
extension CityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cityDataViewModel.filterCityName(with: searchText)
        tableView.reloadData()
        
        if searchText.isEmpty {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



