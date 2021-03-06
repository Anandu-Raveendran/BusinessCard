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
    
    func themeUpdateCallback(){
        _=HomeViewController.updateThemeColor(view: self.view)
    }
    public static func updateThemeColor(view:UIView) -> Bool {
        let userDefaults = UserDefaults.standard
        let colorStr = userDefaults.object(forKey: "ThemeColour") as? String
        if let colorStr = colorStr{
            let color:UIColor
            print("Color set to \(colorStr)")
            switch colorStr{
            case "Indigo": color = UIColor.systemIndigo
            case "Blue": color = UIColor.systemBlue
            case "White": color = UIColor.white
            case "Green": color = UIColor.systemGreen
            case "Teal": color = UIColor.systemTeal
            case "Orange": color = UIColor.systemOrange
            case "Red": color = UIColor.systemRed
            case "Yellow": color = UIColor.systemYellow
            case "Pink": color = UIColor.systemPink
            case "Brown": color = UIColor.systemBrown
            case "Gray": color = UIColor.systemGray
            case "Purple": color = UIColor.systemPurple
            default:color = UIColor.systemBackground
            }
            view.backgroundColor = color
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>> Home ViewController viewDidLoad")
        getLocalyCachedUserData()
    }
    fileprivate func getLocalyCachedUserData() {
        
        if let data = UserDefaults.standard.data(forKey: "UserData"){
            do{
                let decoder = JSONDecoder()
                let localUserData = try decoder.decode(UserDataDao.self, from: data)
                print("Got local user data")
                getUserDataCallback(contact: localUserData) // update ui
                
            } catch {
                print("Error getting local user data")
            }
            
        }
            
    }
 
    override func viewDidAppear(_ animated: Bool) {
        print(">>>> Home ViewController viewDidAppear")
        super.viewDidAppear(animated)

        self.QRCodeImageView.image = nil
        if let uid = Auth.auth().currentUser?.uid {
            print("Setting QR code in main thread")
            QRCodeImageView.image =  AppManager.shared.generateQRCode(from: uid)
        }
        
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
        
        
        if let uid = Auth.auth().currentUser?.uid { // set the logged ??in used uid as the QR code data
            AppManager.shared.getUserDataFireBase(for: uid, callback: getUserDataCallback)
            AppManager.shared.getImageFirebase(for_uid:AppManager.shared.loggedInUID!, callback: gotImageCallback)
        }
        if (HomeViewController.updateThemeColor(view: self.view) == false) {
            performSegue(withIdentifier: "selectThemeSegue", sender: nil)
        }
    }
    
    func gotImageCallback(imageData:Data?){
        if let imageData = imageData {
            print("Home gotImageCallback setting dpimage")
            self.DPimage.image = UIImage(data:imageData)
            AppManager.shared.dpImage = UIImage(data:imageData)
        } else {
            self.DPimage.image = UIImage(systemName: "person.crop.square")
        }
    }
    
    func getUserDataCallback(contact:UserDataDao){
        print("retrieved dict for \(String(describing: contact.name))")
        RegisterViewController.updateLocalData(userData: contact)
        
        if(AppManager.shared.dpImage == nil){
            DPimage.image = UIImage(systemName: "person.crop.square")
        } else {
            DPimage.image = AppManager.shared.dpImage
        }
        print("Home viewDidAppear setting dpImage")
        
        self.name.text = contact.name
        if let emailID = FirebaseAuth.Auth.auth().currentUser?.email {
            self.email.text = emailID
        } else {
            AppManager.shared.logout()
        }
        
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
        } else if(segue.identifier == "selectThemeSegue"){
            let dest = segue.destination as! SelectThemeViewController
            dest.callback = themeUpdateCallback
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
        if(AppManager.shared.dpImage == nil){
            DPimage.image = UIImage(systemName: "person.crop.square")
        } else {
            DPimage.image = AppManager.shared.dpImage
        }
        print("Home imgUploadCallback setting dpImage")
    }

}


