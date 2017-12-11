//
//  PopularPlacesTabBarController.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/12/01.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit
import CoreLocation
class PopularPlacesTabBarController: UITabBarController {
    
    var places: [Venue]?
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
