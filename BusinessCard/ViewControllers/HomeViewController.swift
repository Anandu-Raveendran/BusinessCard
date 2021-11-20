//
//  HomeViewController.swift
//  BusinessCard
//
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var DPimage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    var code:String? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        AppManager.shared.checkLoggedIn(caller: self)
        print("Home view will Appear")
        
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did Appear in Home")
        
        if let uid = AppManager.shared.loggedInUID { // set the logged in used uid as the QR code data
            QRCodeImageView.image = generateQRCode(from: uid)
            
            AppManager.shared.getUserData(for: uid, callback: getUserDataCallback)
            AppManager.shared.getImage(for_uid:AppManager.shared.loggedInUID ?? "", set_to: self.DPimage, is_current_user_dp: true)
        }
    }
    
    func getUserDataCallback(contact:UserDataDao){
        
        
        AppManager.shared.userData?.name = contact.name
        AppManager.shared.userData?.phone = contact.phone
        AppManager.shared.userData?.job_title = contact.job_title
        AppManager.shared.userData?.company_website = contact.company_website
        AppManager.shared.userData?.linkedIn = contact.linkedIn
        
        
        print("retrieved dict for \(String(describing: AppManager.shared.userData?.name))")
        self.name.text = AppManager.shared.userData?.name
        if let emailID = FirebaseAuth.Auth.auth().currentUser?.email {
            self.email.text = emailID
        } else {
            AppManager.shared.logout()
        }
        
    }
    
    
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            guard let QRImage = QRFilter.outputImage else {return nil}
            
            let transformScale = CGAffineTransform(scaleX: 5.0, y: 5.0)
            let scaledQRImage = QRImage.transformed(by: transformScale)
            
            return UIImage(ciImage: scaledQRImage)
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toScanner"){
            let dest = segue.destination as! ScannerViewController
            dest.callback = QRCodeScannerCallback
            dest.calledFrom = "HomeViewController"
        } else if(segue.identifier == "toSettings"){
            let dest = segue.destination as! SettingsViewController
            dest.callback = dataUpdateDone
        }
    }
    func QRCodeScannerCallback(code:String){
        self.code = code
    }
    func dataUpdateDone(){
        print("dataUpdateDone called")
        if let uid = AppManager.shared.loggedInUID {
            AppManager.shared.getUserData(for: uid, callback: getUserDataCallback)
        }
    }
}


