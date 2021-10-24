//
//  HomeViewController.swift
//  BusinessCard
//
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        print("View did Appear in Home")
        AppManager.shared.showApp(caller: self)
        
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
