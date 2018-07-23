//
//  LoginController.swift
//  OnTheMapV1A
//
//  Created by Rick Mc on 6/23/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UINavigationControllerDelegate ,UITextFieldDelegate {
    
    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet weak var errorTextArea: UITextView!
    
    let activityIndicator = UIActivityIndicatorView()
    
    
    @IBAction func loginPressed(_ sender : AnyObject)
    {
   //     errorTextArea.text? = ""
        let usernameText = usernameTextField.text!
        let passwordtext = passwordTextField.text!
        activityIndicator.startAnimating()
        UdacityOTMClient.sharedInstance().authentication(self, usernameText, passwordtext) { (success, data, error) in
            if(success == false)
            {
                self.activityIndicator.stopAnimating()
                if error == "Your request returned a status code other than 2xx!"
                {
                    performUIUpdatesOnMain{
                        self.errorTextArea.text = "Please enter valid email/password"
                    }
                }
                else
                {
                    performUIUpdatesOnMain{
                        self.errorTextArea.text = error
                    }
                }
            }   else {
                self.activityIndicator.stopAnimating()
                performUIUpdatesOnMain{
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "OntheMapTabViewController") as! UITabBarController
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.present(controller, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    func displayActivityIndicator()
    {
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayActivityIndicator()
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
    }
}
