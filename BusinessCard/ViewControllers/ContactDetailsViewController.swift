//
//  ContactDetailsViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-10-31.
//

import UIKit
import FirebaseFirestore

class ContactDetailsViewController: UIViewController {

    var code:String? = nil // the code got from QRcode
    var calledFrom:String? = nil // who is calling this? based on this show UI. save button if logged in
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var jobTitle: UILabel!
    
    @IBOutlet weak var phoneText: UILabel!
    
    @IBOutlet weak var emailIDText: UILabel!
    
    @IBOutlet weak var linkedInText: UILabel!
    
    @IBOutlet weak var comapanyurlText: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var AddToContactBtn: UIBarButtonItem!
    
    @IBAction func AddToContactBtnAction(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let code = code else {
  
            print("Error QR code is empty")
            return
        }

        if let calledFrom = calledFrom {
            if(calledFrom == "GuestViewController"){
                AddToContactBtn.isEnabled = false
            }
            if(calledFrom == "HomeViewController"){
                AddToContactBtn.isEnabled = true
            }
        }
        
     getUserData(for: code)

    }
    
    func getUserData(for uid:String){
        AppManager.shared.db = Firestore.firestore()
        let docRef = AppManager.shared.db.collection("users").document(uid)
        
        docRef.getDocument{
        (document, error) in
            
                       
            if let document = document, document.exists {
                
                let data = document.data()
                
                self.nameText?.text = data?["name"] as? String
                self.phoneText?.text = data?["phone"] as? String
                self.jobTitle?.text = data?["job_title"] as? String
                self.comapanyurlText?.text = data?["company_website"] as? String
                self.linkedInText?.text = data?["linkedIn"] as? String
                
                
                //let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                //print("Retrieved data: \(dataDescription)")
                print("retrieved dict for \(String(describing: data?["name"]))")
                
            } else {
                print("Document does not exit for uid \(uid)")
            }
        }
    }
}
