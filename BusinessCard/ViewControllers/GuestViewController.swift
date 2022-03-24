//
//  GuestViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-01.
//

import UIKit

class GuestViewController: UIViewController {

    var code:String! // code from qr code scanner is saved here
    
    @IBAction func loginBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>> Guest ViewController")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "guestToScanner") {
            let dest = segue.destination as! ScannerViewController
            dest.callback = QRCodeScannerCallback
            dest.calledFrom = "GuestViewController"
        }
#if targetEnvironment(simulator)
         if(segue.identifier == "GuestToDetails"){ // debugging
            let dest = segue.destination as! ContactDetailsViewController
            dest.uid = "TIo5p7aC6RN42GysdIzgAQ77T0v1"
            dest.calledFrom = "GuestViewController"
        }
#endif
    }

#if targetEnvironment(simulator)
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "GuestToDetails", sender: nil)
    }
#endif
    
    func QRCodeScannerCallback(code:String){
        print("GuestViewController callback called")
        self.code = code;
    }
    
}
