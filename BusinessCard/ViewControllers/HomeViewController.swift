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
           
            getUserData(for:uid)
        }
    }
    
    func getUserData(for uid:String){
        AppManager.shared.db = Firestore.firestore()
        let docRef = AppManager.shared.db.collection("users").document(uid)
        
        docRef.getDocument{
        (document, error) in
                       
            if let document = document, document.exists {
                
                let data = document.data()
                
                AppManager.shared.userData?.name = data?["name"] as! String
                AppManager.shared.userData?.phone = data?["phone"] as! Int
                AppManager.shared.userData?.job_title = data?["job_title"] as! String
                AppManager.shared.userData?.company_website = data?["company_website"] as! String
                AppManager.shared.userData?.linkedIn = data?["linkedIn"] as! String
                
                
                //let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                //print("Retrieved data: \(dataDescription)")
                print("retrieved dict for \(String(describing: AppManager.shared.userData?.name))")
                self.name.text = AppManager.shared.userData?.name
                if let emailID = FirebaseAuth.Auth.auth().currentUser?.email {
                    self.email.text = emailID
                } else {
                    AppManager.shared.logout()
                }
                
                AppManager.shared.getImage(for_uid:AppManager.shared.loggedInUID ?? "", set_to: self.DPimage, is_current_user_dp: true)
                
                
            } else {
                print("Document does not exit for uid \(uid)")
            }
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
            getUserData(for:uid)
        }
    }
}


