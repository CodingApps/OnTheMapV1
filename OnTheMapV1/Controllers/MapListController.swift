//
//  MapListController.swift
//  OnTheMapV1A
//
//  Created by Rick Mc on 7/19/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import UIKit
import Foundation

 class MapListController:  UIViewController, UITableViewDelegate , UITableViewDataSource {


    @IBOutlet var tableView : UITableView?
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView?.reloadData()
        print("Count total :",  sharedData.sharedInstance.studentLocations.count )
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        displayList()
    }
    
    
    func displayList()
    {
        
        ParseClient.sharedInstance().getStudentsInformation({(success, data, error) in
            
            performUIUpdatesOnMain {
                if(error != nil)
                {
                    print ("Error loading student data")
                    self.displayAlert("Error", error!, "Cancel")
                }
                else
                {
                    let  studentsArray = data!["results"]  as? [[String : AnyObject]]
                    
                    for student in studentsArray!
                    {
                        sharedData.sharedInstance.studentLocations.append(studentInformation(dictionary : student))
                    }
                    
                    if sharedData.sharedInstance.studentLocations.count != 0
                    {
                        print("count")
                        print(sharedData.sharedInstance.studentLocations.count)
                        performUIUpdatesOnMain {
                            self.tableView?.reloadData()
                        }
                        
                    }
                }
            }
        })
    }
    
    @IBAction func refresh(_ sender : Any)  {
        displayList()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        if(userInformation.objectID == nil){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.present(controller, animated: true, completion: nil)
        }   else {
            displayAlertPop("User has already added a location. Would you like to overwrite?")
        }
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count total :",  sharedData.sharedInstance.studentLocations.count )
        return sharedData.sharedInstance.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "MapListCell") as! MapListCell
        
        let info = sharedData.sharedInstance.studentLocations[(indexPath as NSIndexPath).row]
        
        tableView.rowHeight = 70
        
        if let firstname = info.firstName,let  lastname = info.lastName{
            cell.name.text = "User : \(firstname)"+" "+"\(lastname)"
            cell.URL.text =  info.mediaURL
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = sharedData.sharedInstance.studentLocations[(indexPath as NSIndexPath).row ]
        let url = URL( string : info.mediaURL!)
        
        if url?.scheme != "https"
        {
            displayAlert("","Invalid URL","Dismiss")
        }   else    {
            UIApplication.shared.open(url!)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    @IBAction func logOutButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
