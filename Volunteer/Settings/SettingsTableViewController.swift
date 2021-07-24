//
//  SettingsViewController.swift
//  Volunteer
//
//  Created by Sabrina Slattery on 4/20/21.
//

import UIKit
import Parse
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier:         "LoginViewController")
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                let alert = UIAlertController(title: "Error Logging Out", message: signOutError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    print(signOutError)
                }))
                self.present(alert, animated: true)
            }
        
        loadLoginScreen()
    }

}
