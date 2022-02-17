//
//  ContactListTableViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-16.
//

import UIKit
import FirebaseFirestore
import Firebase

class ContactListTableViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var contacts:[Contact] = [Contact]()
    var selectedContactUid:String? = nil
    var selectedIndex:Int? = nil
    var showCloudCheckDone:Bool = false // cloud backup check is finished or not
    var showCloudAlertDone:Bool = false // Alert showing "cloud backup underway" is closed by user or not
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ContactListTableViewCell", bundle: nil)
        tableView.register( nib, forCellReuseIdentifier: "reuseidentifier")
        
        contacts = AppManager.shared.database.fetchContacts(filter: "") ?? [Contact]()
        if contacts.isEmpty {
            //No contacts in local db hence fetch from firebase
            print("Local Db is empty")
            getFirebaseContactBackup()
        } else {
            print("Local Db is not empty")
        }
        tableView.reloadData()
    }
    
    func getFirebaseContactBackup(){
        AppManager.shared.getContactsFirebase(for_uid: AppManager.shared.loggedInUID!, callback: { res in
            print("Got \(res.count) contactslist uids from cloud ")
            for uid in res {
                AppManager.shared.getUserDataFireBase(for: uid, callback: {userDataDao in
                    if(AppManager.shared.database.saveContact(userDataDao: userDataDao, image: nil)){
                        print("Contact saved to database for uid \(uid)")
                    }
                })
                AppManager.shared.getImageFirebase(for_uid:uid, callback: {res in
                    if let res = res{
                        let tempContact = AppManager.shared.database.fetchContact(uid: uid)
                        tempContact?.image = res
                        AppManager.shared.database.update(data:tempContact! , uid:uid)
                        print("Image added to db for uid \(uid)")
                        self.contacts.append(tempContact!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    self.showCloudCheckDone = true
                })
             
            }
            print("Cloud check done")
            self.showCloudCheckDone = true
    
            if(self.showCloudCheckDone && self.showCloudAlertDone){
                print("Cloud check status: \(self.showCloudCheckDone) and cloud alert \(self.showCloudAlertDone) ")
                if(self.contacts.isEmpty){
                    self.showAlert(title: "No backup in cloud", str: "No contacts were found saved in cloud backup.", completion:nil)
                }
            }
        })
        
        showAlert(title: "Retrieving contact backup", str: "No contacts found in local cache. Trying to retrieving cloud backup", completion: {_ in
            self.showCloudAlertDone = true
            if(self.showCloudCheckDone == false){
                sleep(2)
            }
            
            print("After alert cloud check status \(self.showCloudCheckDone) and cloud alert \(self.showCloudAlertDone) ")
            if(self.showCloudCheckDone && self.showCloudAlertDone){
                if(self.contacts.isEmpty){
                    self.showAlert(title: "No backup in cloud", str: "No contacts were found saved in cloud backup.", completion:nil)
                }
            }
        })
        
    }
    
    func showAlert(title:String, str:String, completion:((UIAlertAction)->Void)?){
        let alertView = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        
        present(alertView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Table elements \(contacts.count)")
        return contacts.count
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Building cell \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseidentifier", for: indexPath) as! ContactListTableViewCell
        cell.nameText.text = contacts[indexPath.row].name
        cell.phone.text = String(contacts[indexPath.row].phone)
        if let data = contacts[indexPath.row].image{
            cell.dpImageView?.image = UIImage(data: data)
            print("Image is set for name \(contacts[indexPath.row].name)")
        } else {
            print("Img data is null")
        }
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContactUid = contacts[indexPath.row].uid
        selectedIndex = indexPath.row
        print("perform segue called")
        performSegue(withIdentifier: "listToContactDetails", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          print("prepare called")
        if(segue.identifier == "listToContactDetails"){
            let dest = segue.destination as! EditContactViewController
            dest.uid = selectedContactUid
            dest.selectedIndex = selectedIndex
        } else {print("identifier is not listToContactDetails")}
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
        contacts = AppManager.shared.database.fetchContacts(filter: searchText) ?? [Contact]()
        tableView.reloadData()

    }

}

extension ContactListTableViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
