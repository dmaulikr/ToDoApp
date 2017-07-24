//
//  FirstItemViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 6/27/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirstItemViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    // Main Storyboard Object References
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    // Firebase Database References
    let UserRef = Database.database().reference(withPath: "users")
    let userIdString : String = (Auth.auth().currentUser?.uid)!

    //MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load user data
        UserRef.child(userIdString).observe(.value, with: { snapshot in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let email = (snapshot.value as! NSDictionary)["email"] as! String
            self.firstName.text = firstName
            self.lastName.text = lastName
            self.email.text = email
            self.userID.text = self.userIdString
            self.navigationItem.title = firstName + " " + lastName
        } )

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
