//
//  AppManager.swift
//  BusinessCard
//
//  Created by Nandu on 2021-10-23.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreData

class AppManager {
    
    static let shared = AppManager()
    var loggedInUID:String? = nil
    var db:Firestore!
    var userData:UserDataDao? = UserDataDao()
    var dpImage:UIImage? = nil
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var contactList = [String]()
    let database = DataSource()
    
    private init() {
        db = Firestore.firestore()
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
            //reset everything. When user logs out and then new user logs in reset everything
            AppManager.shared.dpImage = nil
            AppManager.shared.contactList = []
            AppManager.shared.userData = nil
            AppManager.shared.loggedInUID = nil
            _ = AppManager.shared.database.deleteAll()
            print("Sign out is successful")
        } catch {
            print("sign out error")
        }
    }
    
    func getUserDataFireBase(for uid:String, callback:((UserDataDao)->())?){
        if loggedInUID != nil {
            
        let docRef = AppManager.shared.db.collection("users").document(uid)
        
        docRef.getDocument{
        (document, error) in
                       
            if let document = document, document.exists {
                
                let data = document.data()
                
                var contact = UserDataDao()
                contact.name = data?["name"] as? String ?? ""
                contact.phone = data?["phone"] as? String ?? ""
                contact.job_title = data?["job_title"] as? String ?? ""
                contact.company_website = data?["company_website"] as? String ?? ""
                contact.linkedIn = data?["linkedIn"] as? String ?? ""
                contact.email = data?["email"] as? String ?? ""
                contact.uid = uid
                if let callback = callback{
                    callback(contact)
                }
                
                print("retrieved dict for \(String(describing: contact.name))")
                
            } else {
                print("Document does not exit for uid \(uid)")
            }
        }
        }
    }
    
    func getImageFirebase(for_uid:String,  callback:((Data?)->())?){
        let storage = Storage.storage().reference()
        
        print("getting url for images/\(String(describing: for_uid)).jpeg")
        
        let imageRef = storage.child("images/\(String(describing: for_uid)).jpeg")
        imageRef.downloadURL(completion: { url, error in
            
            if error != nil {
                print("download error occured \(error.debugDescription)")
                if let callback = callback {
                    callback(nil)
                }
                return
            }
            
            print("image url \(String(describing: url!.absoluteURL))")
            
            DispatchQueue.global().async {
                if let data =  try? Data(contentsOf: url!.absoluteURL) {
                    
                    DispatchQueue.main.async {
                        if let callback = callback {
                            callback(data)
                        }
                    }
                } else {print("Data is null")}
            }
            
        })
    }
    
    func getContactsFirebase(for_uid:String, callback:(([String])->())?){
        print("getting contacts from firebase")
        let docRef = db.collection("contactlist").document(for_uid)
        docRef.getDocument{
            (document, error) in
            
            if let document = document, document.exists {
                let data = document.data()
                AppManager.shared.contactList = data?["contacts"] as! [String]
            }
        }
        if let callback = callback {
            callback(self.contactList)
        }
    }
    
    func addContactFirebase(for_uid:String, callback:(()->())?){
        
        print("Add to firebase \(for_uid) to contact list of \(AppManager.shared.loggedInUID) ")
        
        if let loggedInUID = loggedInUID {
            
            AppManager.shared.contactList.append(for_uid)
            AppManager.shared.db.collection("contactlist").document(loggedInUID).setData(["contacts": self.contactList])
            {
                error in
                    
                if(error != nil){
                    print("Error uploading contact \(String(describing: error?.localizedDescription))")
                    return
                }
                print("uploading contact done calling callback")
                if let callback = callback {
                    callback()
                }
           }
        } else {
            print("Couldnt upload contact as user not logged in")
        }
    }
    
    func openUrlInBrowser(for_url:String) {
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
