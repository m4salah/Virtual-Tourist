//
//  TouristImageViewController.swift
//  Virtual Tourist
//
//  Created by Mohamed Abdelkhalek Salah on 5/7/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TouristImageViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet var touristMapView: MKMapView!
    @IBOutlet var touristCollectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    let regionMeter: Double = 5000
    
    var centerCoordinate: CLLocationCoordinate2D!
    var pin: Pin!
    var fetchedResultController: NSFetchedResultsController<Image>!
    var images: [Image] = []

    fileprivate func setupFlowLayout() {
        let space: CGFloat = 1.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHight = (touristMapView.frame.size.height - (2 * space)) / 2.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHight)
    }
    
    fileprivate func setupFetchedResultController() {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalError("cant fetch\(error.localizedDescription)")
        }
        
    }
    
    fileprivate func showAnnotationOnMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
        touristMapView.addAnnotation(annotation)
        touristMapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowLayout()
        setupFetchedResultController()
        showAnnotationOnMap()
        setupImages()
        
        touristCollectionView.delegate = self
        touristCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        touristCollectionView.reloadData()
    }

    
    func setupImages(){
        guard (fetchedResultController.fetchedObjects?.count != 0) else{
            loadImagesFromFlicker()
            return
        }
        images = fetchedResultController.fetchedObjects!
        touristCollectionView.reloadData()
    }
    
    func loadImagesFromFlicker() {
        VTClient.getPhotos(latitude: pin.latitude, longitude:  pin.longitude, numberOfImage: 50, completion: handleFlickerSearchResponse)
    }

    // Show placeholder image for the amount of found images in the search while downloading them
    func handleFlickerSearchResponse(response: [Photo], error: Error?){
        guard error == nil else {
            showAlert(title: "There is something Wrong", message: "i think there is proplem you can try again later")
            return
        }
        
        guard !response.isEmpty else {
            showAlert(title: "Not found images :(", message: "No proplem try somewhere else :D")
            return
        }
        
        images = []
        for photoData in response {
            let image = Image(context:DataController.shared.viewContext)
            image.image = UIImage(named: "ImageLoading")!.pngData()
            images.append(image)
            
            //Download Image
            VTClient.getPhoto(photo: photoData, image: image, completion: handleLoadImage(image:data:error:))
        }
        touristCollectionView.reloadData()
    }
    
    
    // Replace placeholder image with downloaded image and save context
    func handleLoadImage(image: Image, data: Data?, error: Error?){
        guard data != nil, error == nil else {
            images.remove(at: images.firstIndex(of: image)!)
            DataController.shared.viewContext.delete(image)
            return
        }
        
        guard images.contains(image) else{
            return
        }
        
        image.image = data
        image.creationDate = Date()
        image.pin = pin
        try? DataController.shared.viewContext.save()
        DispatchQueue.main.async {
            self.touristCollectionView.reloadData()
        }
    }

    
    func deleteImage(image: Image) {
        DataController.shared.viewContext.delete(image)
        try? DataController.shared.viewContext.save()
    }
    
    @IBAction func newCollectionPressed(_ sender: Any) {
        
        for image in images {
            deleteImage(image: image)
        }
        images = []
        touristCollectionView.reloadData()
        loadImagesFromFlicker()
    }
}

extension TouristImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewId", for: indexPath) as! ImageViewCollectionCell
        if let imageData = images[indexPath.row].image {
            cell.configureUI(image: UIImage(data: imageData))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteImage(image: images[indexPath.row])
        images.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}
