//
//  MapViewController.swift
//  OnTheMapV1A
//
//  Created by Rick Mc on 7/14/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet  var mapView : MKMapView!
    
    var refresh = 0
    var annotations = [MKPointAnnotation]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        callstudentInformation()
        ParseClient.sharedInstance().getStudentInformation({ (success, result, error) in
            
            if(success == false){
                self.displayErrorAlert(error!)
                
            }
            else
            {
                UdacityOTMClient.sharedInstance().getPublicData(userInformation.uniqueKey!) { (success, result, error) in
                    debugPrint ("callsuccess")
                }
            }
            
        })
    }
    
    func displayErrorAlert(_ error : String)
    {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
    }
    
    func callstudentInformation()
    {
        ParseClient.sharedInstance().getStudentsInformation({(success, data, error) in
            
            if(error != nil)
            {
                print ("Error loading student data")
            }
                
            else
            {
                let  studentsArray = data!["results"]  as? [[String : AnyObject]]
                
                for student in studentsArray!
                {
                    sharedData.sharedInstance.studentLocations.append(studentInformation(dictionary: student))
                }
                
                if studentsArray?.count != 0
                {
                    self.markPins(sharedData.sharedInstance.studentLocations,0)
                }
            }
        })
    }
    
    func markPins(_ studentinfo : [studentInformation], _ refresh : Int)
    {
        performUIUpdatesOnMain {
            if(refresh == 1)
            {
                let annotationRefresh = self.mapView.annotations
                
                for i in annotationRefresh{
                    self.mapView.removeAnnotation(i)
                }
                print ("annotations removed after refresh")
            }
            
        }
        
        for student in studentinfo
        {
            if  let latitude = student.latitude,let longitude = student.longitude{
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                let coordinate =   CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                if let firstName = student.firstName,let lastName = student.lastName
                {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = student.mediaURL
                    
                    annotations.append(annotation)
                }
            }
        }
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string : toOpen)
                UIApplication.shared.open(url!)
            }
        }
        
    }
    
    
    @IBAction func addLocation(_ sender: Any) {
        performUIUpdatesOnMain {
            
            
            
        if(userInformation.objectID == nil){
            
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                self.navigationController?.pushViewController(controller, animated: true)
              
            }
                
            else
            {
                self.displayAlertPop("User has already added a location. Would you like to overwrite?")
                
            }
        }
    }
    
    @IBAction func refresh(_ sender : Any)
    {
        ParseClient.sharedInstance().getStudentsInformation({(success, data, error) in
            
            if(error != nil)
            {
                self.displayAlert("Error", error!, "Cancel")
            }
                
            else
            {
                let  studentsArray = data!["results"]  as? [[String : AnyObject]]
                
                for student in studentsArray!{
                    sharedData.sharedInstance.studentLocations.append(studentInformation(dictionary: student))
                }
                if studentsArray?.count != 0
                {
                    self.markPins(sharedData.sharedInstance.studentLocations,1)
                }
            }
        })
    }

    func displayAlertPop( _ message : String)
        
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
           let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.navigationController?.pushViewController(controller, animated: true)
       }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func displayAlert(_ title : String, _ message : String , _ action : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: {action in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
                    self.dismiss(animated: false, completion: nil)
    }
    
    
}
