//
//  SignUpViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 6/27/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    // Main Storyboard Object References
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // Firebase Database References
    let RootRef = Database.database().reference()
    let UserRef = Database.database().reference(withPath: "users")
    var CurrentUser: User!
    
    //MARK: Override Functions
    
    // viewDidLoad(): called after the view controller has loaded its
    // view hierarchy into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text Field Delegate
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        
        // Text Field Tags
        firstName.tag = 0
        lastName.tag = 1
        email.tag = 2
        password.tag = 3
        
        // Load Controller Background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "deepSeaBackground")?.draw(in: self.view.bounds)
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        } else {
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
    }
    
    // didReceiveMemoryWarning(): called when the system determines that the amount
    // of available memory is low
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    // textFieldShouldReturn(): user pressed the return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the next responder
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: Functions
    
    // recordUserInDatabase(): records user data in Firebase Database
    func recordUserInDatabase() {
        let currentUserInfo = (["firstName": firstName.text!,
                                   "lastName": lastName.text!,
                                   "email": email.text!,
                                   "website": ""])
        let CurrentUserRef = self.UserRef.child(CurrentUser.uid)
        CurrentUserRef.setValue(currentUserInfo)
    }
    
    // createFirebaseUser(): record user data in Firebase Authentication
    func createFirebaseUser() {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            if error == nil {
                print("You have successfully signed up!")
                //self.signInSegue()
                self.CurrentUser = Auth.auth().currentUser
                self.recordUserInDatabase()
                self.signUpSegue()
            } else {
                let alertController = UIAlertController(title: "Please try again...", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                    print("Printing action now")
                    print(action)
                    self.firstName.text = ""
                    self.lastName.text = ""
                    self.email.text = ""
                    self.password.text = ""
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Actions
    
    // onClickSignUp(): validate form and create Firebase user
    @IBAction func onClickSignUp(_ sender: UIButton) {
        if firstName.text == "" || lastName.text == "" {
            let alertController = UIAlertController(title: "", message: "Please enter your first and last name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else if email.text == "" {
            let alertController = UIAlertController(title: "", message: "Please enter an email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else if password.text!.characters.count < 6 {
            let alertController = UIAlertController(title: "", message: "Please enter a password with 6 characters or more", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            createFirebaseUser()
        }
    }
    
    //MARK: Functions
    
    // signInSegue(): segue to the Tab Bar Controller
    func signUpSegue() {
        performSegue(withIdentifier: "signUpSegue", sender: nil)
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
