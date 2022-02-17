//
//  HomeViewController.swift
//  BusinessCard
//
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Network

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
    
    
    func showAlert(str:String){
        let alertView = UIAlertController(title: "Network status", message: str, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertView, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did Appear in Home")
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { Path in
            if Path.status != .unsatisfied {
                print("We are connected to internet")
               
            } else {
                print("Not Connected to internet")
                DispatchQueue.main.async {
                    self.showAlert(str: "Internet connection not found. Some feature will not work as expected.")
                }
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        
        if let uid = AppManager.shared.loggedInUID { // set the logged ßin used uid as the QR code data
            QRCodeImageView.image = HomeViewController.generateQRCode(from: uid)
            
            AppManager.shared.getUserDataFireBase(for: uid, callback: getUserDataCallback)
            AppManager.shared.getImageFirebase(for_uid:AppManager.shared.loggedInUID!, callback: gotImageCallback)
        }
    }
    
    func gotImageCallback(imageData:Data?){
        if let imageData = imageData {
            self.DPimage.image = UIImage(data:imageData)
            AppManager.shared.dpImage = UIImage(data:imageData)
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
    
    public static func generateQRCode(from string: String) -> UIImage? {
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
            dest.imgUploadCallback = imgUploadCallback
        }
    }
    func QRCodeScannerCallback(code:String){
        self.code = code
    }
    func dataUpdateDone(){
        print("dataUpdateDone called")
        if let uid = AppManager.shared.loggedInUID {
            AppManager.shared.getUserDataFireBase(for: uid, callback: getUserDataCallback)
        }
    }
    func imgUploadCallback(){
        print("imageUpdateDone called")
        if let uid = AppManager.shared.loggedInUID {
            DPimage.image = AppManager.shared.dpImage
        }
    }

}


