//
//  HomeViewController.swift
//  BusinessCard
//
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    
    @IBOutlet weak var QRCodeImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        AppManager.shared.showApp(caller: self)
        print("Home view will Appear")
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did Appear in Home")
        
        QRCodeImageView.image = generateQRCode(from: "Details not added. But i wanted to see how much of data I could save in it. So I put this super long string over here so that we could see the output in real. I think this is a really good long string")
        
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

}
