//
//  BookmarksTableVC.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/26/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import CoreData

class BookmarksTableVC: UITableViewController {
    
    var cities = [Location]()
    let bookmarkPresenter: CityPresenterProtocol = BookmarkPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cities = bookmarkPresenter.loadCities()
        self.tableView.reloadData()
        self.tableView.separatorColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.cities = bookmarkPresenter.loadCities()
        self.tableView.reloadData()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cities.count > 0 {
            hideTableEmptyMessage()
            return 1
        } else {
            showTableEmptyMessage(message: "You don't have any bookmarks yet,\n Click on map to save  \n a bookmark.")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! BookmarkTableViewCell
        cell.cityDetails(location: cities[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            bookmarkPresenter.deleteCity(index: indexPath.row)
            self.cities = bookmarkPresenter.loadCities()
            self.tableView.reloadData()
            
        } else if editingStyle == .insert {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let weatherDetails = storyBoard.instantiateViewController(withIdentifier: "WeatherReport") as! WeatherViewController
        weatherDetails.latitude = cities[indexPath.row].lat
        weatherDetails.longitude = cities[indexPath.row].long
        weatherDetails.title = cities[indexPath.row].city ?? "Weather"
        self.navigationController?.pushViewController(weatherDetails, animated: true)
    }
    
    
    // MARK: - Table Animation
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let reotate = CATransform3DTranslate(CATransform3DIdentity, 0,40, 0)
        cell.layer.transform = reotate
        cell.alpha = 0
        cell.accessoryView = UIImageView(image: UIImage(named: "5.png"))
        UIView.animate(withDuration: 0.9){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    //MARK: - Private Functions
    
    func showTableEmptyMessage(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 16)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    func hideTableEmptyMessage() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}
