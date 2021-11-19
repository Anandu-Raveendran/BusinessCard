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
    var dpImage:UIImage? = nil
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var contactList = [String]()
    
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
    
    func getImage(for_uid:String, set_to:UIImageView, is_current_user_dp: Bool){
        let storage = Storage.storage().reference()

        print("getting url for images/\(String(describing: for_uid)).jpeg")
              
        let imageRef = storage.child("images/\(String(describing: for_uid)).jpeg")
        imageRef.downloadURL(completion: { url, error in
                
            if error != nil {
                print("download error occured \(error.debugDescription)")
                return
            }
            
            print("image url \(String(describing: url!.absoluteURL))")
            
            DispatchQueue.global().async {
                if let data =  try? Data(contentsOf: url!.absoluteURL) {
                
                    DispatchQueue.main.async {
                        set_to.image = UIImage(data: data)
                        if is_current_user_dp {
                            AppManager.shared.dpImage = set_to.image
                        }
                    }
                } else {print("Data is null")}
            }
            
        })
    }
    
    func openUrl(for_url:String) {
        var mainUrl:URL!
        
        if let url = URL(string: for_url), UIApplication.shared.canOpenURL(url) {
            mainUrl = url
        } else if let url = URL(string: "http://\(for_url)"), UIApplication.shared.canOpenURL(url)  {
            mainUrl = url
        } else if let url = URL(string: "https://\(for_url)"), UIApplication.shared.canOpenURL(url)  {
            mainUrl = url
        } else {
            print("Cant open company website\(String(describing: for_url))")
            return
        }
        
        print("Opening \(String(describing: mainUrl))")
        if #available(iOS 10.0, *){
            UIApplication.shared.open(mainUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(mainUrl)
        }
        
    }

    
}
