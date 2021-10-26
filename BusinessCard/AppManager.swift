//
//  AppManager.swift
//  BusinessCard
//
//  Created by Nandu on 2021-10-23.
//

import UIKit
import Firebase
import FirebaseFirestore

class AppManager {
    
    static let shared = AppManager()
    var loggedInUID:String? = nil
    var db:Firestore!
    var userData:UserDataDao? = UserDataDao()
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    private init() {
        
    }
    
    func checkLoggedIn(caller:UIViewController){
        var viewController: UIViewController
        

        if(FirebaseAuth.Auth.auth().currentUser == nil) {
            print("User is not logged in")
            viewController = storyBoard.instantiateViewController(identifier: "LoginPageViewController")
            viewController.modalPresentationStyle = .fullScreen
            caller.present(viewController, animated: false, completion: nil)
            
        } else {
            print("User is logged in")
            AppManager.shared.loggedInUID = FirebaseAuth.Auth.auth().currentUser?.uid
        }
    }
    
    func logout() {
       // caller.navigationController?.popToRootViewController(animated: true)
       // caller.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        do {
            try Auth.auth().signOut()
            print("Sign out is successful")
        } catch {
            print("sign out error")
        }
    }
    
}
