//
//  CoreDataManager.swift
//  SimpleWeatherApp
//
//  Created by Ayca Akman on 24.05.2023.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleWeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveToCoreData(cities: [CityData]) {
        cities.forEach { cityData in
            let city = City(context: context)
            city.id = Int64(cityData.id)
            city.name = cityData.name
            saveContext()
        }
    }
    
    func fetchFromCoreData() -> [City] {
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        do {
            let cities = try context.fetch(fetchRequest)
            return cities
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
