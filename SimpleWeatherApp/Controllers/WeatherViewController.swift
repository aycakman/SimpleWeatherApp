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
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
