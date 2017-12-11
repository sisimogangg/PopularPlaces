//
//  PlacePhotosViewController.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/27.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit
import Alamofire


class PlacePhotosViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: PlacePhotosViewModel?
    
    var selectedVenueId: String?
    
    private var selectedVenuePhotos: [VenuePhoto]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var selectedVenue: SelectedVenue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemSize = UIScreen.main.bounds.width/3 - 6
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake( 20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        
        collectionView.collectionViewLayout = layout
        
        if let chosen = selectedVenue{
        viewModel = PlacePhotosViewModel(with: chosen)
            viewModel?.photosChanged = {[weak self] in
                self?.selectedVenuePhotos = self?.viewModel?.selectedVenuePhotos
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedVenuePhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        
        if let photos = selectedVenuePhotos {
            let photo: VenuePhoto = photos[indexPath.row]
            if let photoCell = cell as? VenuePhotosCollectionViewCell {
                photoCell.photo = photo
            }
        }
        
        return cell
    }
    

    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedPhotoViewController = segue.destination.body as? SelectedPhotoViewController {
            if let collectionViewCell =  sender as? UICollectionViewCell{
                if let currentCell = collectionViewCell as? VenuePhotosCollectionViewCell {
                    selectedPhotoViewController.navigationItem.title = "Selected"
                    selectedPhotoViewController.photo = currentCell.photo
                }
            }
        }
    }
    
    
}
extension UIViewController
{
    var body: UIViewController{
        if let containerNavCon = self as? UINavigationController{
            return containerNavCon.visibleViewController ?? self
        }else {
            return self
        }
    }
}
