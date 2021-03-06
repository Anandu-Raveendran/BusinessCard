//
//  EditContactViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2022-02-04.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class EditContactViewController: UIViewController {

    var uid:String? = nil
    var selectedIndex:Int? = nil
    var contact:Contact? = nil // get from database
    
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    @IBOutlet weak var DpImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var companyWebsite: UITextField!
    @IBOutlet weak var linkedIn: UITextField!
  
    @IBAction func SaveContactBtn(_ sender: UIButton) {
        contact?.name = name.text
        contact?.email = email.text
        contact?.phone = phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        if let contact = contact, let sindex = selectedIndex{
            _=AppManager.shared.database.update(data:contact, index:sindex)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func DeleteContactBtn(_ sender: UIButton) {
       _=AppManager.shared.database.delete(data: contact!, index: selectedIndex!)
       self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>> Edit Contact ViewController")

        QRCodeImage.image = AppManager.shared.generateQRCode(from: uid!)
        
        contact = AppManager.shared.database.fetchContact(uid: uid!)
        if let contact = contact{
            updateUIData(contact: contact)
        } else {
            AppManager.shared.getUserDataFireBase(for: uid!, callback: getUserDataCallback)
            AppManager.shared.getImageFirebase(for_uid: uid!, callback: gotImageCallback)
        }
    }
    
    func gotImageCallback(imageData:Data?){
        if let imageData = imageData {
            self.DpImage.image = UIImage(data:imageData)
        } else{
            self.DpImage.image = UIImage(systemName: "person.crop.square")
        }
    }
    
    func getUserDataCallback(contact:UserDataDao){
        name.text = contact.name
        phone.text = String(contact.phone)
        email.text = contact.email
        jobTitle.text = contact.job_title
        companyWebsite.text = contact.company_website
        linkedIn.text = contact.linkedIn
     }
    
    
    func updateUIData(contact:Contact){
        if let img = contact.image{
            DpImage.image = UIImage(data:img)
        }
        name.text = contact.name
        phone.text = contact.phone
        email.text = contact.email
        jobTitle.text = contact.job_title
        companyWebsite.text = contact.companyUrl
        linkedIn.text = contact.linkedInUrl
        
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
