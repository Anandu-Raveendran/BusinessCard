//
//  PasswordResetViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-21.
//

import UIKit
import FirebaseAuth

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var errorMessageField: UILabel!
    @IBOutlet weak var emailField: UITextField!

    @IBAction func sendPasswordResetBtn(_ sender: Any) {
        var errorMessage = ""
        if let email = emailField.text {
            
            if(!RegisterViewController.isEmailValid(email)){
                errorMessage += " Email ID not valid"
            } else {
                Auth.auth().sendPasswordReset(withEmail: email, completion: {
                    error in
                    if let error = error{
                        errorMessage += "Error \(error.localizedDescription)"
                    } else {
                        errorMessage = "Password reset mail sent"
                        sleep(1)
                        self.dismiss(animated: true)
                    }
                })
            }
        } else {
            errorMessage += "Email id is empty"
        }
    
        errorMessageField.text = errorMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>> Password Reset ViewController")

        // Do any additional setup after loading the view.
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
