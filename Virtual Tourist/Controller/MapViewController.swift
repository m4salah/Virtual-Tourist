//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Mohamed Abdelkhalek Salah on 5/7/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let defaults = UserDefaults.standard
    
    var fetchedResultController: NSFetchedResultsController<Pin>!
    
    fileprivate func setupFetchedResultController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalError("cant fetch\(error.localizedDescription)")
        }
        
    }
    
    fileprivate func annotationOnMap() {
        var annotations = [AnnotationPin]()
        
        for pin in fetchedResultController!.fetchedObjects! {
            let coord = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            let annotation = AnnotationPin(coordinate: coord, pin: pin)
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    fileprivate func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "OK"
        navigationItem.backBarButtonItem = backButton
        navigationItem.title = "Virtual Tourist"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultController()
        setupNavigationBar()
        annotationOnMap()
        
        mapView.delegate = self
        
        let longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 0.2
        longGesture.addTarget(self, action: #selector(longPressed))
        mapView.addGestureRecognizer(longGesture)
        
        if let region = loadRegion(withKey: "mapregion") {
            mapView.region = region
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultController = nil
        saveRegion(withKey: "mapregion")
    }
    
    @objc func longPressed(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.began {
            return
        }
        let point = gestureRecognizer.location(in: mapView)
        let coord = mapView.convert(point, toCoordinateFrom: mapView)
        
        let pin = Pin(context: DataController.shared.viewContext)
        pin.latitude = coord.latitude
        pin.longitude = coord.longitude
        pin.creationDate = Date()
        try? DataController.shared.viewContext.save()
        
        let annotation = AnnotationPin(coordinate: coord, pin: pin)
        mapView.addAnnotations([annotation])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TouristImageSegue", let controller = segue.destination as? TouristImageViewController {
            let senderLocation = sender as! AnnotationPin
            controller.centerCoordinate = senderLocation.coordinate
            controller.pin = senderLocation.pin
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! AnnotationPin
        performSegue(withIdentifier: "TouristImageSegue", sender: annotation)
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        saveRegion(withKey: "mapregion")
    }
}

extension MapViewController {
    func saveRegion(withKey key:String) {
        let locationData = [mapView.region.center.latitude, mapView.region.center.longitude,
                            mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta]
        defaults.set(locationData, forKey: key)
    }
    
    func loadRegion(withKey key:String) -> MKCoordinateRegion? {
        guard let region = defaults.object(forKey: key) as? [Double] else { return nil }
        let center = CLLocationCoordinate2D(latitude: region[0], longitude: region[1])
        let span = MKCoordinateSpan(latitudeDelta: region[2], longitudeDelta: region[3])
        return MKCoordinateRegion(center: center, span: span)
    }
}
