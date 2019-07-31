//
//  WeatherViewController.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/26/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    let network: NetworkManager = NetworkManager.sharedInstance
    let alert = Alert()
    
    var weatherPresenter: WeatherDelegate = WeatherDetailsPresenter()
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
        weatherInfo()
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
    
    func weatherInfo(){
        weatherPresenter.getWeatherData(Longitude : self.longitude ,Latitude : self.latitude) { (error, result) in
            if (error == nil) {
                guard let result = result else {
                    return
                }
                self.updateUIWithWeatherData(result as! WeatherDataModel)
            }
        }
    }
    
    func updateUIWithWeatherData(_ weather: WeatherDataModel) {
        cityLabel.text = weather.city ?? ""
        temperatureLabel.text = "\(weather.temperature ?? 0)°"
        weatherIcon.image = UIImage(named: weather.weatherIconeName)
        weatherDescription.text = weather.description ?? ""
        country.text = weather.country ?? ""
        windSpeed.text = String(weather.windSpeed ?? 0)
        windDegree.text = String(weather.windDegree ?? 0)
        humidity.text = String(weather.humidity ?? 0)
        
    }
}


