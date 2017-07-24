//
//  SignInViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 6/26/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    // Main Storyboard Object References
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Override Functions
    
    // viewDidLoad(): called after the view controller has loaded its
    // view hierarchy into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text Field Delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Text Field Tags
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
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
    
    // textFieldShouldReturn() called when the user hits the return button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the next responder in the View Controller
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            // Close the Keyboard
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: Actions
    
    // onClickSignIn(): check if fields are fill in and sign user in
    @IBAction func onClickSignIn(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully logged in!")
                    self.signInSegue()
                }
                else{
                    let alertController = UIAlertController(title: "Please try again...", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                        print("Printing action now")
                        print(action)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: Functions
    
    // signInSegue(): segue to the Tab Bar Controller
    func signInSegue() {
        performSegue(withIdentifier: "signInSegue", sender: nil)
    }
    
    // onClickForgotPassword(): not ready yet
    @IBAction func onClickForgotPassword(_ sender: UIButton) {
        print("Forgot Password feature not ready yet")
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
