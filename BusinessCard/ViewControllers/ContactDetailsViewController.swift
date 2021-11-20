//
//  ContactDetailsViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-10-31.
//

import UIKit
import FirebaseFirestore

class ContactDetailsViewController: UIViewController {

    var uid:String? = nil // the code got from QRcode
    var calledFrom:String? = nil // who is calling this? based on this show UI. save button if logged in
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var jobTitle: UILabel!
    
    @IBOutlet weak var phoneText: UILabel!
    
    @IBOutlet weak var emailIDText: UILabel!
    
    @IBOutlet weak var linkedInText: UIButton!
    
    @IBOutlet weak var comapanyurlText: UIButton!
    
    
    @IBAction func companyWebsiteClicked(_ sender: Any) {
        AppManager.shared.openUrl(for_url: comapanyurlText.currentTitle!)
    }
   
    @IBAction func linkedInclicked(_ sender: Any) {
        AppManager.shared.openUrl(for_url: linkedInText.currentTitle!)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var AddToContactBtn: UIBarButtonItem!
    
    @IBAction func AddToContactBtnAction(_ sender: Any) {
        //Add contacts to mycontact list
        AppManager.shared.getContacts(for_uid: AppManager.shared.loggedInUID!, callback: nil)
        AppManager.shared.addContact(for_uid: AppManager.shared.loggedInUID!, callback: nil)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let code = uid else {
  
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
        
     getUserData(for_uid: code)
        AppManager.shared.getImage(for_uid: code, set_to: profilePic, is_current_user_dp: false)
     self.hideKeyboardWhenTappedAround()


    }
    
    func getUserData(for_uid uid:String){
        
        print("finding data for user id \(uid)")
        
        AppManager.shared.db = Firestore.firestore()
        let docRef = AppManager.shared.db.collection("users").document(uid)
        
        docRef.getDocument{
        (document, error) in
            
                       
            if let document = document, document.exists {
                
                let data = document.data()
                
                self.nameText?.text = data?["name"] as? String
                self.phoneText?.text = data?["phone"] as? String
                self.jobTitle?.text = data?["job_title"] as? String
                self.comapanyurlText?.setTitle(data?["company_website"] as? String, for: .normal)
                self.linkedInText?.setTitle(data?["linkedIn"] as? String, for: .normal)
                                
                //let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                //print("Retrieved data: \(dataDescription)")
                print("retrieved dict for \(String(describing: data?["name"]))")
                
            } else {
                print("Document does not exit for uid \(uid)")
            }
        }
    }
    
}
extension ContactDetailsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ContactDetailsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

