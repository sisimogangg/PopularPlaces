//
//  SelectedPhotoViewController.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/29.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit

class SelectedPhotoViewController: UIViewController {
    
    //@IBOutlet weak var placeNameLabel: UILabel!

    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    // @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var selectedImageImageView: UIImageView!
    var photo: VenuePhoto?

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func loadData(){
        if let photo = photo, let user = photo.user {
            var name = ""
            if let firstName  = user.firstName {
                 name = firstName
                if let lastName = user.lastname {
                    name += " \(lastName)"
                }
            }
        userNameLabel.text = "By: \(name)"
            sourceLabel.text = "Via: \(photo.source.name)"
            placeNameLabel.text = photo.venueName
            
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = photo.url {
                if let imageData = try?Data(contentsOf: url){
                    DispatchQueue.main.async {
                        self?.selectedImageImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        }
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
