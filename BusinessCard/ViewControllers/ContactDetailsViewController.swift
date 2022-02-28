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
    var userDetails:UserDataDao? = nil
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var jobTitle: UILabel!
    
    @IBOutlet weak var phoneText: UILabel!
    
    @IBOutlet weak var emailIDText: UILabel!
    
    @IBOutlet weak var linkedInText: UIButton!
    
    @IBOutlet weak var comapanyurlText: UIButton!
    
    
    @IBAction func companyWebsiteClicked(_ sender: Any) {
        AppManager.shared.openUrlInBrowser(for_url: comapanyurlText.currentTitle!)
    }
   
    @IBAction func linkedInclicked(_ sender: Any) {
        AppManager.shared.openUrlInBrowser(for_url: linkedInText.currentTitle!)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var AddToContactBtn: UIBarButtonItem!
    
    @IBAction func AddToContactBtnAction(_ sender: Any) {
        //Add contacts to mycontact list
        AppManager.shared.getContactsFirebase(for_uid: AppManager.shared.loggedInUID!, callback: nil)
        AppManager.shared.addContactFirebase(for_uid: uid!, callback: nil)
        if let data = userDetails{
            AppManager.shared.database.saveContact(uid: data.uid,
                                                   name: data.name ,		
                                                   phone: data.phone,
                                                   email: data.email,
                                                   companyUrl: data.company_website,
                                                   linkedIn: data.linkedIn,
                                                   job_title: data.job_title,
                                                   image: profilePic.image?.jpegData(compressionQuality: 1))
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(">>>> ContactDetails ViewController")

        print("Called from is \(calledFrom)")
        
        if let calledFrom = calledFrom {
            if(calledFrom == "GuestViewController"){
                AddToContactBtn.isEnabled = false
            } else if(calledFrom == "HomeViewController"){
                AddToContactBtn.isEnabled = true
            }
        }
        
            guard let code = uid else {
                print("Error QR code is empty")
                return
            }
            AppManager.shared.getUserDataFireBase(for: code, callback: getUserDataCallback)
            AppManager.shared.getImageFirebase(for_uid:AppManager.shared.loggedInUID!, callback: gotImageCallback)
        
        self.hideKeyboardWhenTappedAround()
    }

    func gotImageCallback(imageData:Data?){
        if let imageData = imageData {
            self.profilePic.image = UIImage(data:imageData)
        } else {
            self.profilePic.image = UIImage(systemName: "person.crop.square")
        }
    }

    func getUserDataCallback(contact:UserDataDao){
               
        userDetails = contact
        updateUIData(contact: contact)
    }

    func updateUIData(contact:UserDataDao){
            
        self.nameText?.text = contact.name
        self.phoneText?.text = String(contact.phone)
        self.jobTitle?.text = contact.job_title
        self.comapanyurlText?.setTitle(contact.company_website, for: .normal)
        self.linkedInText?.setTitle(contact.linkedIn, for: .normal)
        self.emailIDText?.text = contact.email
                                
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

