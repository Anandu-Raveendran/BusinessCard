//
//  AppManager.swift
//  BusinessCard
//
//  Created by Nandu on 2021-10-23.
//

import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    private init() {
        
    }
    
    func showApp(caller:UIViewController){
        var viewController: UIViewController
        if(FirebaseAuth.Auth.auth().currentUser == nil) {
            print("User is logged in")
            viewController = storyBoard.instantiateViewController(identifier: "LoginPageViewController")
            viewController.modalPresentationStyle = .fullScreen
            caller.present(viewController, animated: true, completion: nil)
            
        } else {
            print("User is not logged in")
        }
    }
    
    func logout(caller:UIViewController) {
        do {
            try Auth.auth().signOut()
            print("Sign out is successful")
            showApp(caller: caller)
        } catch {
            print("sign out error")
        }
    }
    
}
