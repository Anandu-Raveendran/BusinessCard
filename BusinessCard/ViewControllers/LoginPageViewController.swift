//
//  ViewController.swift
//  BusinessCard
//
//

import UIKit
import Firebase

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginBtn(_ sender: Any) {
        var errorMessage = ""
        
        guard let email = emailText.text else {
            errorMessage += " Email field is empty"
            errorText.text = errorMessage
            return
        }
        
        guard let pass = password.text else {
            errorMessage += " Password is empty"
            errorText.text = errorMessage
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass, completion: { [weak self] result, error in
            
            guard let strongSelf = self else {return}
            
            if( error != nil) {
                print("User Not found")
                strongSelf.errorText.text = "User not found"
                return
            }
            
            print("\(email) Login success")
            strongSelf.errorText.text = "Login success"
            
            strongSelf.dismiss(animated: true, completion: nil)
            
        })
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        if(FirebaseAuth.Auth.auth().currentUser == nil) {
            performSegue(withIdentifier: "guestSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
}

