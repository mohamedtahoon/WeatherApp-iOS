//
//  WeatherViewController.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/26/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController ,WeatherDelegate{
    
    
    let network: NetworkManager = NetworkManager.sharedInstance
    let alert = Alert()
    
    var weatherPresenter = WeatherDetailsPresenter(weatherService: WeatherService())
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var windDegree: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.reachability.whenUnreachable = { reachability in
            self.showAlert()
        }
        NetworkManager.isUnreachable { _ in
            self.showAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        weatherPresenter.weatherInfo(long: longitude, lat: latitude)
        weatherPresenter.setViewDelegate(weatherDelegate: self)
    }
    
    // MARK: - Show Alert When Connection Lost
    private func showAlert() -> Void {
        print("inside show Alert When No Internet Connection")
        DispatchQueue.main.async {
            self.alert.showAlert(title: "Connection Lost", message: "Plz Check Internet Connection To Get Weather Information ", actions:[(title:"Ok",action: {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            })])
        }
    }
    
    
    
    func updateUIWithWeatherData(_ weather: (temperature: Int, city: String, icon: String, humidity: Int, windDegree: Int, windSpeed: Float, description: String, country: String, condition: Int)) {
        cityLabel.text = weather.city 
        temperatureLabel.text = "\(weather.temperature )°"
        weatherIcon.image = UIImage(named: weather.icon)
        weatherDescription.text = weather.description 
        country.text = weather.country 
        windSpeed.text = String(weather.windSpeed )
        windDegree.text = String(weather.windDegree )
        humidity.text = String(weather.humidity )
        
    }
}


