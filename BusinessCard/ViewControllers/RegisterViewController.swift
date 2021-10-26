//
//  RegisterViewController.swift
//  BusinessCard
//
//  
//

import UIKit
import Firebase
import FirebaseFirestore

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
        
        guard let email = emailIdField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            errorMessage += " Email field is empty"
            errorField.text = errorMessage
            return
        }
        
        if(!RegisterViewController.isEmailValid(email)){
            errorMessage += " Email ID not valid"
        }
        
        guard let pass = passwordField.text else {
            errorMessage += " Password is empty"
            errorField.text = errorMessage
            return
        }
        
        if(!RegisterViewController.isPasswordValid(pass)){
            errorMessage += " Password is not strong enough"
        }
        
        guard let name = nameField.text else {
            errorMessage += " Name is empty"
            errorField.text = errorMessage
            return
        }
        
        let phone = Int(phoneNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0")
        
        let linkedIn = linkedInUrl.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let company_website = companyUrlField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let jobTitle = jobTitleField.text ?? ""
        
        if(errorMessage.isEmpty || errorMessage == "") {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion: {
                [weak self] result, error in
                
                guard let strongSelf = self else {return}
                
                guard error == nil else{
                    print("Account creation failed \(String(describing: error?.localizedDescription))")
                    strongSelf.errorField.text = "Account creation failed"
                    return
                }
                
                print("\(email) Signed in")
                strongSelf.errorField.text = "Account created"
                AppManager.shared.loggedInUID = result?.user.uid
                AppManager.shared.db = Firestore.firestore()
                
                AppManager.shared.db.collection("users").document(result!.user.uid).setData([                               "name":name, "phone":phone!,                                                                          "linkedIn":linkedIn,                                                                                 "company_website":company_website,                                                                   "job_title": jobTitle])
                {
                    error in
                    
                    if(error != nil){
                        print("User data create error \(String(describing: error?.localizedDescription))")
                    }
                }
                strongSelf.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            })
        } else{
            errorField.text = errorMessage
        }
    }
    
    
    static func isEmailValid(_ email:String) -> Bool{
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
        
    }
    
    static func isPasswordValid(_ pass:String) -> Bool{
        
        let passRegx = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$"
        
        var returnValue = true
        
        do {
            let regex = try NSRegularExpression(pattern: passRegx)
            let nsString = pass as NSString
            let results = regex.matches(in: pass, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
}
