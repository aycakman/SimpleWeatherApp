//
//  City.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 27.05.2023.
//

import Foundation
import RealmSwift

class City: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var id: Int = 0
}
