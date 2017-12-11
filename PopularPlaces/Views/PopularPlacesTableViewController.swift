//
//  PopularPlacesTableViewController.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/25.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import os

class PopularPlacesTableViewController: UITableViewController {
    private var viewModel: PopularPlacesViewModel?
    private var places: [Venue]?{
        didSet{
            tableView.reloadData()
            updateParentController()
        }
    }
    
    private var selectedVenueId: String?
    private var selectedVenue: SelectedVenue?
    

    var currentLocation : CLLocation?
    let util = Util()
    
    
    
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationLabel = UILabel()
        locationLabel.font = UIFont.fontAwesome(ofSize: 20)
        locationLabel.text = "\(String.fontAwesomeIcon(code: "fa-map-marker")!) Place around you"
        locationLabel.textColor = UIColor.white
        locationLabel.sizeToFit()
        
        self.tabBarController!.navigationItem.titleView = locationLabel
        
        if let location = currentLocation {
            
            let testClass = PopularPlacesCViewModel(location: location)
            //print("Testing : \(testClass!.currentLocation!)")
            
            
            
            testClass?.addObserver(self, forKeyPath: "test", options: NSKeyValueObservingOptions.new, context: nil)
            
            testClass?.test = "New Value"
            
            //print("My location \(location.coordinate)")
            viewModel = PopularPlacesViewModel(using: location)
            viewModel!.placesChanged = {[weak self] in
                self?.places = self?.viewModel?.places
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places?.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceRow", for: indexPath)
        
        if let venues = places {
            let place: Venue = venues[indexPath.row]
            if let placeCell = cell as? VenueTableViewCell{
                placeCell.venue = place
            }
        }
        
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let destinationViewController = segue.destination
        if let placePhotosViewController = destinationViewController as? PlacePhotosViewController,
            let identifier = segue.identifier ,
            identifier == "photosSegue" {
            
            if let TableViewCell =  sender as? UITableViewCell{
                if let placeTableViewCell = TableViewCell as? VenueTableViewCell {
                    placePhotosViewController.navigationItem.title = placeTableViewCell.venue?.name
                    if let venue = placeTableViewCell.venue {
                        placePhotosViewController.selectedVenue = SelectedVenue(id: venue.id, name: venue.name)
                    }
                }
            }
            
        }
        
        
        
    }
    
    // MARK: - Helpers
    private func updateParentController(){
        if let tbc = self.tabBarController as? PopularPlacesTabBarController{
            tbc.places = self.places
            tbc.currentLocation = self.currentLocation
        }
    }
    
}
