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


class MapViewController: UIViewController, UISearchBarDelegate  {
    let network: NetworkManager = NetworkManager.sharedInstance
    let alert = Alert()
    
    var mapPresenter: MapPresenterProtocol = MapViewPresenter()
    
    @IBOutlet weak var mapView: MKMapView!
    let alertView : UIView = UIView()
    
    //Search in Map
    @IBAction func searchBtn(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                self.alert.showAlert(title: "Error", message: "Sorry, the City Name you entered is not correct", actions:[(title:"Try Again",action: {
                    self.dismiss(animated: true, completion: nil)
                })])
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                
                //let annotation = MKPointAnnotation()
                //annotation.title = searchBar.text
                //annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                //self.mapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    
    
    
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
