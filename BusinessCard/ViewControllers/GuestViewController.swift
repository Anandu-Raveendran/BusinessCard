//
//  GuestViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-01.
//

import UIKit

class GuestViewController: UIViewController {

    var code:String! // code from qr code scanner is saved here
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "guestToScanner") {
            let dest = segue.destination as! ScannerViewController
            dest.callback = QRCodeScannerCallback
            dest.calledFrom = "GuestViewController"
        }
    }

    func QRCodeScannerCallback(code:String){
        self.code = code;
    }
    
}
