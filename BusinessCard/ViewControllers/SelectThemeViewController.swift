//
//  SelectThemeViewController.swift
//  BusinessCard
//
//  Created by Anandu on 2022-02-26.
//

import UIKit

class SelectThemeViewController: UIViewController {
    
    private var color:String? = nil
    public var callback:(()->())? = nil

    @IBAction func indigo(_ sender: UIButton) {
        color = "Indigo"
        updateTheme()
    }
    @IBAction func blue(_ sender: UIButton) {
        color = "Blue"
        updateTheme()
    }
    @IBAction func grey(_ sender: UIButton) {
        color = "White"
        updateTheme()
    }
    @IBAction func green(_ sender: UIButton) {
        color = "Green"
        updateTheme()
    }
    @IBAction func teal(_ sender: UIButton) {
        color = "Teal"
        updateTheme()
    }
    @IBAction func orange(_ sender: UIButton) {
        color = "Orange"
        updateTheme()
    }
    @IBAction func red(_ sender: UIButton) {
        color = "Red"
        updateTheme()
    }
    @IBAction func yellow(_ sender: UIButton) {
        color = "Yellow"
        updateTheme()
    }
    @IBAction func pink(_ sender: UIButton) {
        color = "Pink"
        updateTheme()
    }
    @IBAction func brown(_ sender: UIButton) {
        color = "Brown"
        updateTheme()
    }
    @IBAction func darkGrey(_ sender: UIButton) {
        color = "Gray"
        updateTheme()
    }
    @IBAction func purple(_ sender: UIButton) {
        color = "Purple"
        updateTheme()
    }
    
    func updateTheme(){
        print("Setting theme to \(String(describing: color))")
        let userDefaults = UserDefaults.standard
        userDefaults.set(color, forKey: "ThemeColour")
            if let callback = self.callback {
                print("select theme controller callback being called")
                callback()
            } else {
                print("select theme controller callback is nil")
            }
        dismiss(animated: true, completion: nil)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
