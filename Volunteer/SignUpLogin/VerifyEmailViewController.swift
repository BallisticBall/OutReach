//
//  VerifyEmailViewController.swift
//  Volunteer
//
//  Created by William Ordaz on 2/22/21.
//

import Parse
import Foundation
import UIKit
import FirebaseAuth

class VerifyEmailViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
    }
	@IBAction func onLogIn(_ sender: Any) {
		PFUser.logOutInBackground()
		performSegue(withIdentifier: "BackToLogin", sender: self)
	}
    
    @IBAction func onSendCode(_ sender: Any){
        
        let currentUser = Auth.auth().currentUser
        let actionCodeSettings = ActionCodeSettings()
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
    }
	
	@IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
