//
//  QRCodeView.swift
//  BusinessCard
//
//  Created by Nandu on 2021-10-24.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins


class QRCodeView{
    
    static func generateQRCodeImage(_ url: String) -> Image {
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(url.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return Image(uiImage: UIImage(cgImage: qrCodeCGImage)).interpolation(.none)
                    .resizable()
            }
        }
        
        return Image("null")
    }
}

