//
//  RegisterViewController.swift
//  BusinessCard
//
//  
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailIdField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var linkedInUrl: UITextField!
    
    @IBOutlet weak var companyUrlField: UITextField!
    
    @IBOutlet weak var errorField: UILabel!
    
    @IBAction func submitBtn(_ sender: Any) {
        
        var errorMessage = ""
        
        guard let email = emailIdField.text else {
            errorMessage += " Email field is empty"
            errorField.text = errorMessage
            return
        }
       
        
        guard let pass = passwordField.text else {
            errorMessage += " Password is empty"
            errorField.text = errorMessage
            return
        }
        
        guard let name = nameField.text else {
            errorMessage += " Name is empty"
            errorField.text = errorMessage
            return
        }
        
        if(errorMessage.isEmpty || errorMessage == "") {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion: {
                [weak self] result, error in
                
                guard let strongSelf = self else {return}
                
                guard error == nil else{
                    print("Account creation failed")
                    strongSelf.errorField.text = "Account creation failed"
                    return
                }
                
                print("\(email) Signed in")
                strongSelf.errorField.text = "Account created"
                AppManager.shared.showApp(caller: strongSelf)
            })
        } else{
            errorField.text = errorMessage
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
