//
//  BookmarkTableViewCell.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/26/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var country: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func cityDetails(location: Location){
        cityName.text = location.city
        country.text = location.country
    }
}
