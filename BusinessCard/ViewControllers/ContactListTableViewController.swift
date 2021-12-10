//
//  ContactListTableViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-16.
//

import UIKit
import FirebaseFirestore
import Firebase

class ContactListTableViewController: UITableViewController {

    var contacts:[Contact] = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let nib = UINib(nibName: "ContactListTableViewCell", bundle: nil)
        tableView.register( nib, forCellReuseIdentifier: "reuseidentifier")
        
        contacts = AppManager.shared.database.fetchContacts(filter: "") ?? [Contact]()
        if contacts.isEmpty {
            //No contacts in local db hence fetch from firebase
            print("Local Db is empty")
            AppManager.shared.getContactsFirebase(for_uid: AppManager.shared.loggedInUID!, callback: nil)
        } else {
            print("Local Db is not empty")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Table elements \(contacts.count)")
        return contacts.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Building cell \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseidentifier", for: indexPath) as! ContactListTableViewCell
        cell.nameText.text = contacts[indexPath.row].name
        cell.phone.text = String(contacts[indexPath.row].phone)
        cell.dpImageView?.image = UIImage(data: contacts[indexPath.row].image ?? Data())
       
        
        return cell
    }
   
}
