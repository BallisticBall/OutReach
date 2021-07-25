//
//  UpdateEmailViewController.swift
//  Volunteer
//
//  Created by Sabrina Slattery on 4/23/21.
//

import UIKit
import Parse
import Firebase
import FirebaseDatabase
import FirebaseAuth


class UpdateEmailViewController: UIViewController {
    
    @IBOutlet weak var currentEmail: UILabel!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var confirmNewEmail: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newEmail.resignFirstResponder()
        confirmNewEmail.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    func userEmail(){
        let currentUser = Auth.auth().currentUser
        let userEmail = currentUser?.email
        self.currentEmail?.text = userEmail
        print(userEmail!)
        
    }
    
    @IBAction func submitForm(_ sender: Any) {
        if  (self.newEmail.text != self.confirmNewEmail.text) {
            let userMessage = "Emails must match."
            let myAlert = UIAlertController(title:"Please try again", message:userMessage, preferredStyle: UIAlertController.Style.alert);
                            
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion:nil);
        }
        else if !newEmail.hasText || !confirmNewEmail.hasText {
            let userMessage = "Cannot submit null or mismatching fields."
            let myAlert = UIAlertController(title:"Please try again.", message:userMessage, preferredStyle: UIAlertController.Style.alert);
                            
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion:nil);
        }
        else {
            
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            actionCodeSettings.url = URL(string: "https://www.example.com")

            let currentUser = Auth.auth().currentUser
            let email = currentUser?.email
            Auth.auth().sendSignInLink(toEmail: email!,
                                       actionCodeSettings: actionCodeSettings) { error in
              // ...
                if let error = error {
                  print(error.localizedDescription)
                  return
                }
                // The link was successfully sent. Inform the user.
                // Save the email locally so you don't need to ask the user for it again
                // if they open the link on the same device.
                UserDefaults.standard.set(email!, forKey: "Email")
                print("Check your email for link")
                // ...
            }

            
            
//            let query = PFQuery(className: "User")
//            query.whereKey("user", equalTo: PFUser.current()!)
//            query.getFirstObjectInBackground { [self] (object, error) -> Void in
//                if error == nil {
//                    let result = object
//                    result!["email"] = self.newEmail.text
//                    result?.saveInBackground() {
//                        (success: Bool, error: Error?) in
//                            if (success) {
//                                // The object has been saved.
//                            let userMessage = "Email successfully updated."
//                            let myAlert = UIAlertController(title:"Success!", message:userMessage, preferredStyle: UIAlertController.Style.alert);
//
//                            let okAction =  UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction!) -> Void in
//                                self.performSegue(withIdentifier: "returnToSettings", sender: nil)
//                                })
//                            myAlert.addAction(okAction);
//                            self.present(myAlert, animated:true, completion:nil);
//                            }
//                            else {
//                                let userMessage = "There was an error"
//                                let myAlert = UIAlertController(title:"Please try again.", message:userMessage, preferredStyle: UIAlertController.Style.alert);
//                                let okAction =  UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
//                                myAlert.addAction(okAction);
//                                self.present(myAlert, animated:true, completion:nil);
//                            }
//                    }
//                }
//        }
            
            
        }
    }
}
