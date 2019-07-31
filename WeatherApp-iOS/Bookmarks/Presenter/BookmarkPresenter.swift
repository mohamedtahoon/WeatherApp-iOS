//
//  BookmarkPresenter.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/26/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import CoreData

protocol CityPresenterProtocol {
    
    func loadCities() -> [Location]
    func deleteCity(index: Int)
}

class BookmarkPresenter: CityPresenterProtocol {
    var cities : [Location] = []
    
    func loadCities() -> [Location] {
        let fetchRequest : NSFetchRequest<Location> = Location.fetchRequest()
        do {
            cities  = try context.fetch(fetchRequest)
        } catch {
            print("No Data Found")
        }
        return cities
    }
    
    func deleteCity(index: Int) {
        
        do {
            context.delete(cities[index])
            cities.remove(at: index)
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
}
