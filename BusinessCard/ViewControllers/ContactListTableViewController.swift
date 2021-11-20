//
//  ContactListTableViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-16.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    var contacts:[Contact]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        contacts = AppManager.shared.database.fetchContacts(filter: "")
        if contacts == nil {
            //No contacts in local db hence fetch from firebase
            AppManager.shared.getContactsFirebase(for_uid: AppManager.shared.loggedInUID!, callback: getContactBackUp)
        }
    }
    
    func getContactBackUp(contactlist:[String]){
        for contactId in contactlist {
            AppManager.shared.getUserDataFireBase(for: contactId, callback: gotContact)
        }
    }
    
    func gotContact(contact:UserDataDao){
        AppManager.shared.getImageFirebase(for_uid:contact.uid, callback: gotImageCallback)
    }


func gotImageCallback(imageData:Data?){
    if let imageData = imageData {
    }
}

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppManager.shared.contactList.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ContactTableViewCell
        

        

        return cell
    }
   
}
