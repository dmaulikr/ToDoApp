//
//  EditProfileViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 6/28/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
//import FirebaseDatabase
import FirebaseStorage
import os.log

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var websiteText: UITextField!
    //@IBOutlet weak var profilePictureImage: UIImageView!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    let databaseUsers = Database.database().reference(withPath: "users")
    var storageRef = Storage.storage().reference()
    
    // Logged in user ID
    let userIdString : String = (Auth.auth().currentUser?.uid)!
    
    //var CurrentUser: User!
    
    // Variable for image picker
    // var imagePicker = UIImagePickerController()
    
    //MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Text Field Delegate
        firstNameText.delegate = self
        lastNameText.delegate = self
        emailText.delegate = self
        websiteText.delegate = self
        
        
        // Reference to current logged in user
        
        // Load Firebase Database User Information
        databaseUsers.child(userIdString).observe(.value, with: { snapshot in
            let firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            let lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            let email = (snapshot.value as! NSDictionary)["email"] as! String
            
            // Load Website or set it to "" if website field DNE
            if (snapshot.value as! NSDictionary)["website"] == nil {
                self.websiteText.text = ""
            } else {
                let website = (snapshot.value as! NSDictionary)["website"] as! String
                self.websiteText.text = website
            }
            
            // Profile Picutre
            /*if (snapshot.value as! NSDictionary)["profilePicture"] != nil {
             let profilePicture = (snapshot.value as! NSDictionary)["profilePicture"] as! String
             let data = NSData(contentsOf: NSURL(string: profilePicture)! as URL)
             self.setProfilePicture(imageView: self.profilePictureImage, imageToSet:UIImage(data:data! as Data)!)
             }*/
            
            self.firstNameText.text = firstName
            self.lastNameText.text = lastName
            self.emailText.text = email
            self.navigationItem.title = firstName + " " + lastName
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    // textFieldShouldReturn() called when the user hits the return button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Functions
    
    // Set Profile Picture Image Function
    /*internal func setProfilePicture(imageView: UIImageView, imageToSet: UIImage) {
     imageView.layer.cornerRadius = 10.0
     imageView.layer.borderColor = UIColor.white.cgColor
     imageView.layer.masksToBounds = true
     imageView.image = imageToSet
     }
     
     func dismissFullScreenImage(sender: UITapGestureRecognizer) {
     // remove the larger image from the view
     sender.view?.removeFromSuperview()
     }*/
    
    //MARK: Actions
    
    /*@IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
     // Create an action sheet
     /*let myActionSheet = UIAlertController(title:"Profile Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
     
     let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertActionStyle.default) { (action) in
     
     let imageView = sender.view as! UIImageView
     let newImageView = UIImageView(image: imageView.image)
     
     newImageView.frame = self.view.frame
     
     newImageView.backgroundColor = UIColor.black
     newImageView.contentMode = .scaleAspectFit
     newImageView.isUserInteractionEnabled = true
     
     let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage))
     
     newImageView.addGestureRecognizer(tap)
     self.view.addSubview(newImageView)
     }*/
     
     /*let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in {
     if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.savedPhotosAlbum) {
     self.imagePicker.delegate = self
     self.imagePicker.source.Type = UIImagePickerControllerSourceType.savedPhotosAlbum
     self.imagePicker.allowsEditing = true
     self.presentedViewController.imagePicker, animated: ture. completion: nil
     }
     }*/
     }*/
    
    @IBAction func signOutButton(_ sender: UIButton) {

        // Signs user out of Firebase Authentication
        // Moves the view to the Sign In Screen
        try! Auth.auth().signOut()
        
        // Reference to Main.storyboard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Reference to SignInViewController
        let signInViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "signInViewController")
        
        // Animation to SignInViewController
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    
    // cancelButton(): animation to ProfileViewController
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveBarButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let thisFirstName = firstNameText.text ?? ""
        let thisLastName = lastNameText.text
        let thisEmail = emailText.text
        let thisWebsite = websiteText.text
        
        print("First Name: " + thisFirstName)
        print("Last Name: " + thisLastName!)
        print("Email: " + thisEmail!)
        print("Website: " + thisWebsite!)
        
        //let updateUserInfo = User(firstName: thisFirstName, lastName: thisLastName, email: thisEmail)
        //databaseUsers.child(userIdString).setValue(updateUserInfo.toAnyObject())
        databaseUsers.child(userIdString).setValue(["firstName": thisFirstName,
                                                    "lastName": thisLastName,
                                                    "email": thisEmail,
                                                    "website": thisWebsite])
    }
    
}
