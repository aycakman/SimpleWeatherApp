//
//  BigWeatherViewCell.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 23.05.2023.
//

import UIKit

class BigWeatherViewCell: UITableViewCell {

    @IBOutlet weak var viewArea: UIView!
    @IBOutlet weak var valueTwoLabel: UILabel!
    @IBOutlet weak var valueOneLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewArea.layer.cornerRadius = viewArea.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
