//
//  MapViewController.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/25/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController  {
    let network: NetworkManager = NetworkManager.sharedInstance
    let alert = Alert()
    
    var mapPresenter: MapPresenterProtocol = MapViewPresenter()
    
    @IBOutlet weak var mapView: MKMapView!
    let alertView : UIView = UIView()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.reachability.whenUnreachable = { reachability in
            self.showAlert()
            
        }
        NetworkManager.isUnreachable { _ in
            self.showAlert()
            // self.tabBarController!.selectedIndex = 0
            
        }
        super.viewWillAppear(true)
    }
    
    
    // MARK: - Show Alert When Connection Lost
    private func showAlert() -> Void {
        print("inside show Alert When No Internet Connection")
        DispatchQueue.main.async {
            self.alert.showAlert(title: "Connection Lost", message: "Please Check The Internet Connection To Get Weather Information ", actions:[(title:"Ok",action: {
                
                if self.tabBarController?.selectedIndex == 1 {
                    self.tabBarController?.selectedIndex = 0
                }
            })])
        }
    }
    
    
    private func setLongPressGesture() -> Void {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPinOnMap(press:)))
        longPressGesture.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    
    // MARK: - Add Pin On Selected location On Map
    @objc func addPinOnMap(press : UILongPressGestureRecognizer) {
        
        if press.state == .ended {
            let point = press.location(in: self.mapView)
            let coordinates = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            //  add pin on selected coordinates
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = coordinates
            self.mapView.addAnnotation(pointAnnotation)
            
            
            mapPresenter.confirmAddingCity(coordinate: pointAnnotation.coordinate) { AlertAction in
                switch AlertAction {
                case .cancel:
                    self.mapView.removeAnnotation(pointAnnotation)
                case .confirm:
                    self.mapView.addAnnotation(pointAnnotation)
                }
            }
        }
    }
}
