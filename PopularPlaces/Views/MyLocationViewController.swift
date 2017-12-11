//
//  ViewController.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/22.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GoogleMaps
import FontAwesome_swift

class MyLocationViewController: UIViewController, CLLocationManagerDelegate  {
    
    // MARK: Properties
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet{
            getAddress()
            updateMap()
        }
    }
    
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet weak var getPlacesBtn: UIButton!
    
    private var enableBtn = false {
        didSet{
            showButton()
        }
    }
    
    var currentAddress: String?
    
    
    
    // MARK: View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        let locationLabel = UILabel()
        locationLabel.font = UIFont.fontAwesome(ofSize: 20)
        locationLabel.text = "\(String.fontAwesomeIcon(code: "fa-map-marker")!) Location"
        locationLabel.textColor = UIColor.white
        locationLabel.sizeToFit()
        
        navigationItem.titleView = locationLabel
        
        mapView.delegate = self
        // If location services is enabled get the users location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        getPlacesBtn.layer.cornerRadius = 4
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        getLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let popularPlacesViewController = segue.destination.bodyViewController as? PopularPlacesTableViewController,
            let identifier = segue.identifier ,
            identifier == "getPlacesSeque" ,
            let location = currentLocation {
            popularPlacesViewController.currentLocation = location
        }
        
    }
    
    // MARK: - Handlers
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.first {
            currentLocation = location
            locationManager.stopUpdatingLocation()
        }
    }
    
    /* If we have been denied access give the user the option to change it */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if(status == CLAuthorizationStatus.denied){
            warnUser()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    // MARK: - Helpers
    private func getLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation() //not advisable best to use 'requestLocation' method ?
        }
    }
    private func warnUser() {
        let alert = UIAlertController(title: "Enable Location", message: "Please enable location for PopularPlaces", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func getAddress() {
        CLGeocoder().reverseGeocodeLocation(currentLocation!) {[weak self](placemark, error) in //force unwrapping currentlocation since this method will only be called when it is in a set state
            if error != nil{
                print("error")
            }else{
                if let place = placemark?[0],
                    let subThofare = place.subThoroughfare ,
                    let thofare = place.thoroughfare ,
                    let country = place.country {
                    self?.currentAddress = "\(subThofare) \n \(thofare) \n \(country)"
                    
                }
            }
        }
    }
    
    private func showButton(){
        if enableBtn {
            getPlacesBtn.isEnabled = true
        }else {
            getPlacesBtn.isEnabled = false
        }
    }
    
    private func updateMap(){
        if let coordinate = currentLocation?.coordinate{
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
            mapView.camera = camera
            showMarker(position: camera.target)
            addButtonToMap()
        }
    }
    
    private func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Durban"
        marker.snippet = "South Africa"
        marker.map = mapView
        
        mapView.selectedMarker = marker
    
    }
    
    private func addButtonToMap(){
        getPlacesBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        getPlacesBtn.setTitle("\(String.fontAwesomeIcon(name: .foursquare)) Places around you", for: .normal)
        mapView.addSubview(getPlacesBtn)
    }
}

// MARK: - Extenstions
extension MyLocationViewController: GMSMapViewDelegate{
    

    /* handles Info Window tap */
    public func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
        performSegue(withIdentifier: "getPlacesSeque", sender: marker)
    }
    
    
    /* Creating Custom Window */
    public func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let viewHeaderLabel = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        viewHeaderLabel.text = "You're Here"
        viewHeaderLabel.textColor = UIColor.orange
        view.addSubview(viewHeaderLabel)
        
        let viewAddressSection = UILabel(frame: CGRect.init(x: viewHeaderLabel.frame.origin.x, y: viewHeaderLabel.frame.origin.y + viewHeaderLabel.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        viewAddressSection.lineBreakMode = .byTruncatingTail
        viewAddressSection.numberOfLines = 0
        viewAddressSection.text =  "View places around you"
        viewAddressSection.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(viewAddressSection)
        
        return view
    }
}

extension UIViewController
{
    var bodyViewController: UIViewController{
        if let containerNavCon = self as? UITabBarController{
            return containerNavCon.customizableViewControllers![0]
        }else {
            return self
        }
    }
}

