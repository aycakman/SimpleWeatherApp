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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityNameViewCell", bundle: nil), forCellReuseIdentifier: "CityNameViewCell")
        // Do any additional setup after loading the view.
        if let localData = cityManager.readLocalFile(forName: "city.list") {
            cityManager.parse(jsonData: localData)
        }
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

extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameViewCell", for: indexPath) as! CityNameViewCell
        return cell
    }
    
    
    
}
