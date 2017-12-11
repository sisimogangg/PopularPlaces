//
//  PopularPlaceMapViewController.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/12/01.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit
import GoogleMaps

class PopularPlaceMapViewController: UIViewController {
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    var currentPlace: Venue?
    var util: Util?
    
    var imageDictionary: Dictionary = [GMSMarker: UIImage]()
    var markerArray  = [GMSMarker]()
    private var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        util = Util();
    
        if let tbc = self.tabBarController as? PopularPlacesTabBarController, let places = tbc.places{
            //print(places[0].name)
            if let location = tbc.currentLocation{
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
                mapView.camera = camera
            }
            for place in places{
                currentPlace = place
                if let lat = place.lat, let lon = place.lon {
                    let loc = CLLocation(latitude: lat, longitude: lon)
                    showMarker(position: loc.coordinate)
                }
            }
            updateBounds(places: places)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - Helpers
    private func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Palo Alto"
        marker.snippet = "San Francisco"
        marker.map = mapView
        mapView.selectedMarker = marker
    }
    
    private func updateBounds(places: [Venue]){
        var bounds = GMSCoordinateBounds()
        for place in places {
            if let lat = place.lat, let lon = place.lon {
                let loc = CLLocation(latitude: lat, longitude: lon)
                bounds = bounds.includingCoordinate(loc.coordinate)
                
            }
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0)))
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// MARK: - Extenstions
extension PopularPlaceMapViewController: GMSMapViewDelegate{
    
    
    /* handles Info Window tap */
    public func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        if let selectedMarker = mapView.selectedMarker{
            selectedMarker.icon = GMSMarker.markerImage(with: nil)
        }
        
        mapView.selectedMarker = marker
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        //print("didTapInfoWindowOf")
        //performSegue(withIdentifier: "getPlacesSeque", sender: marker)
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let selectedMarker = mapView.selectedMarker{
            selectedMarker.icon = GMSMarker.markerImage(with: nil)
        }
        
        mapView.selectedMarker = marker
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        return true
    }
    
    
    /* Creating Custom Window */
    public func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let imageViewObject = UIImageView(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 32))
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        if let url = self?.currentPlace?.photoUrl {
            if let imageData = try?Data(contentsOf: url){
                DispatchQueue.main.async {
                    imageViewObject.image = UIImage(data: imageData)
                }
            }
        }
        }
        
        let viewAddressSection = UILabel(frame: CGRect.init(x: imageViewObject.frame.origin.x, y: imageViewObject.frame.origin.y + imageViewObject.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        viewAddressSection.text = currentPlace?.address
        
        view.addSubview(imageViewObject)
        view.addSubview(viewAddressSection)
        
        return view
    }
}
