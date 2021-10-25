//
//  SettingsViewController.swift
//  BusinessCard
//
//  Created by Nandu on 2021-10-23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func logoutBtn(_ sender: Any) {
        super.viewDidLoad()

        print("Logout from settings")
        AppManager.shared.logout()
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

        // Do any additional setup after loading the view.
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
