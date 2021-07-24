//
//  SignUpViewController.swift
//  Volunteer
//
//  Created by William Ordaz on 2/21/21.
//

import Foundation
import UIKit
import Parse
import AlamofireImage
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SignUpViewController:UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phonenumberField: UITextField!
    //@IBOutlet weak var profileImageView: UIImageView!
    //@IBOutlet weak var tapToChangeProfileButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    

    var ref = Database.database().reference()
 
    
    //var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)

        
        firstnameField.delegate = self
        lastnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        firstnameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        lastnameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
		
		
    }
    
    // Storing username and password in the database 
    @IBAction func signUp(_ sender: Any){
        
        
        
		if !firstnameField.hasText || !lastnameField.hasText || !emailField.hasText || !passwordField.hasText {
			let alert = UIAlertController(title: "Oops!", message: "Please fill out all of the required information", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
				
			}))
			self.present(alert, animated: true)
			print("Error:")
		} else {

            
            let username = emailField.text!
            let password = passwordField.text!
            let email = emailField.text!
            let firstname = firstnameField.text!
            let lastname = lastnameField.text!
            
            //Firebase Signup
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as? NSError {
                  var error_message = "blank"

                  switch AuthErrorCode(rawValue: error.code) {
                  
                  case .operationNotAllowed:
                    error_message = "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section."
                  case .emailAlreadyInUse:
                    error_message = "The email address is already in use by another account."
                  case .invalidEmail:
                    error_message = "The email address is badly formatted."
                  case .weakPassword:
                    error_message = "The password must be 6 characters long or more"
                  default:
                    error_message = error.localizedDescription
                  }
                    let alert = UIAlertController(title: "Oops!", message: error_message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        print(error.debugDescription)
                    }))
                    self.present(alert, animated: true)
                } else {
                  print("User signs up successfully")
                    let uid = Auth.auth().currentUser!.uid
                    self.ref.child("users/\(uid)/username").setValue(username)
                    self.ref.child("users/\(uid)/firstname").setValue(firstname)
                    self.ref.child("users/\(uid)/lastname").setValue(lastname)

                    self.performSegue(withIdentifier: "ToSetupProfile", sender: nil)



                
                }
            }
            
		}
}
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstnameField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firstnameField.resignFirstResponder()
        lastnameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
//        continueButton.center = CGPoint(x: view.center.x,
//                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
//        activityView.center = continueButton.center
    }
    
    
    @objc func textFieldChanged(_ target:UITextField) {
        let firstName = firstnameField.text
        let lastName = lastnameField.text
        let email = emailField.text
        let password = passwordField.text
        let formFilled = firstName != nil && firstName != "" && lastName != nil && lastName != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstnameField:
            firstnameField.resignFirstResponder()
            lastnameField.becomeFirstResponder()
            break
        case lastnameField:
            lastnameField.resignFirstResponder()
            emailField.becomeFirstResponder()
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            //handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    
   
    
    
    
    
    func resetForm() {
        let alert = UIAlertController(title: "Error signing up", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setContinueButton(enabled: true)
        continueButton.setTitle("Continue", for: .normal)
        activityView.stopAnimating()
    }
    
    
   
}
