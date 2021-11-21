//
//  ContactListTableViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-16.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    var contacts:[Contact] = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        contacts = AppManager.shared.database.fetchContacts(filter: "") ?? [Contact]()
        if contacts.isEmpty {
            //No contacts in local db hence fetch from firebase
            print("Local Db is empty")
            AppManager.shared.getContactsFirebase(for_uid: AppManager.shared.loggedInUID!, callback: getContactBackUp)
        } else {
            print("Local Db is not empty")
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
        print("Table elements \(contacts.count)")
        return contacts.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Building cell \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ContactTableViewCell
        cell.nameField.text = contacts[indexPath.row].name
        cell.phoneField.text = String(contacts[indexPath.row].phone)
        cell.imageView?.image = UIImage(data: contacts[indexPath.row].image ?? Data())

        return cell
    }
   
}
