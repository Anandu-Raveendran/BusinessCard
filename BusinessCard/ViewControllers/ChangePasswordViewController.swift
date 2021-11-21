//
//  ChangePasswordViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-21.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var errorMessageField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func updatePasswordBtn(_ sender: Any) {
        if let pass = newPasswordField.text {
            if( !pass.isEmpty){
                if(!RegisterViewController.isPasswordValid(pass)){
                    errorMessageField.text = " Password is not strong enough"
                    return
                }
            } else {
                errorMessageField.text = "New Password is empty"
                return
            }
        } else {
            errorMessageField.text = "New Password is empty"
            return
        }
        
        if let oldPass = oldPasswordField.text {
            if( !oldPass.isEmpty){
                errorMessageField.text = "Old Password is empty"
                return
            }
        } else {
            errorMessageField.text = "Old Password is empty"
            return
        }
        
        if let pass = newPasswordField.text {
            if( !pass.isEmpty){
                let credential = EmailAuthProvider.credential(withEmail: Auth.auth().currentUser?.email ?? "", password: oldPasswordField.text!)
        
                Auth.auth().currentUser?.reauthenticate(with: credential) { (authDatresult, error) in
                    if let error = error{
                        self.errorMessageField.text? += "Reauthentication Error \(error.localizedDescription)"
                        return
                    }
                
                    Auth.auth().currentUser?.updatePassword(to: pass, completion: {(error) in
                        if(error != nil){
                            self.errorMessageField.text = "Password update failed"
                            return
                        }
                    })
                }
            }
        }
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
