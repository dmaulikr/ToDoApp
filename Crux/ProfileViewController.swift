//
//  ProfileViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 6/28/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import os.log

class ProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var website: UITextField!
    
    
    let UserRef = Database.database().reference(withPath: "users")
    let userIdString : String = (Auth.auth().currentUser?.uid)!
    var CurrentUser: User!
    
    //MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load Firebase Database User Information
        UserRef.child(userIdString).observe(.value, with: { snapshot in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let email = (snapshot.value as! NSDictionary)["email"] as! String
            if (snapshot.value as! NSDictionary)["website"] == nil {
                self.website.text = ""
            } else {
                let website = (snapshot.value as! NSDictionary)["website"] as! String
                self.website.text = website

            }
            
            self.firstName.text = firstName
            self.lastName.text = lastName
            self.email.text = email
            self.navigationItem.title = firstName + " " + lastName
        } )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func unwindToProfilePage(sender: UIStoryboardSegue) {
        print("Unwining segue from save button")
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
