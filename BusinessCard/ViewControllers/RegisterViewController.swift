//
//  RegisterViewController.swift
//  BusinessCard
//
//  
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class RegisterViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private let storage = Storage.storage().reference()
    private var image:UIImage? = nil
    
    @IBOutlet weak var emailIdField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var linkedInUrl: UITextField!
    
    @IBOutlet weak var companyUrlField: UITextField!
    
    @IBOutlet weak var errorField: UILabel!
    
    @IBOutlet weak var dpImageView: UIImageView!
    
    @IBAction func UploadImageBtn(_ sender: Any) {
        openImagePicker()
    }
    
    
    @IBAction func submitBtn(_ sender: Any) {
        
        var errorMessage = ""
        
        guard let email = emailIdField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            errorMessage += " Email field is empty"
            errorField.text = errorMessage
            return
        }
        
        if(!RegisterViewController.isEmailValid(email)){
            errorMessage += " Email ID not valid"
        }
        
        guard let pass = passwordField.text else {
            errorMessage += " Password is empty"
            errorField.text = errorMessage
            return
        }
        
        if(!RegisterViewController.isPasswordValid(pass)){
            errorMessage += " Password is not strong enough"
        }
        
        guard let name = nameField.text else {
            errorMessage += " Name is empty"
            errorField.text = errorMessage
            return
        }
        
        let phone = Int(phoneNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0")
        
        let linkedIn = linkedInUrl.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let company_website = companyUrlField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let jobTitle = jobTitleField.text ?? ""
        
        if(errorMessage.isEmpty || errorMessage == "") {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion: {
                [weak self] result, error in
                
                guard let strongSelf = self else {return}
                
                guard error == nil else{
                    print("Account creation failed \(String(describing: error?.localizedDescription))")
                    strongSelf.errorField.text = "Account creation failed"
                    return
                }
                
                print("\(email) Signed in")
                strongSelf.errorField.text = "Account created"
                AppManager.shared.loggedInUID = result?.user.uid
                AppManager.shared.db = Firestore.firestore()
                self?.uploadImage()
                
                AppManager.shared.db.collection("users").document(result!.user.uid).setData([
                    "name":name, "phone":phone!,
                    "linkedIn":linkedIn,
                    "company_website":company_website,
                    "job_title": jobTitle                ])
                {
                    error in
                    
                    if(error != nil){
                        print("User data create error \(String(describing: error?.localizedDescription))")
                    }
                }
                strongSelf.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            })
        } else{
            errorField.text = errorMessage
        }
    }
    
    
    static func isEmailValid(_ email:String) -> Bool{
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
        
    }
    
    static func isPasswordValid(_ pass:String) -> Bool{
        
        let passRegx = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$"
        
        var returnValue = true
        
        do {
            let regex = try NSRegularExpression(pattern: passRegx)
            let nsString = pass as NSString
            let results = regex.matches(in: pass, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
}

extension RegisterViewController {
    
    func openImagePicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.image = image
                
        dpImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(){
        guard let imageData = image?.jpegData(compressionQuality: 0.2) else {
            return
        }
        let imagename = AppManager.shared.loggedInUID

        print("Trying to upload image of size \(imageData.count)")

        let imageRef = storage.child("images/\(String(describing: imagename!)).jpeg")
        let uploadTask = imageRef.putData(imageData, metadata: nil, completion:{ metadata, error in
            	
            guard let _ = metadata else {
                print("upload error occured")
                return
            }
            
           
        })
        uploadTask.observe(.failure) {(storageTaskSnapshot) in
            
            if let error = storageTaskSnapshot.error as NSError? {
              switch (StorageErrorCode(rawValue: error.code)!) {
                // Common errors
                case .unauthenticated:
                  print("Error: Unauthenticated; User has not yet logged in ")
                case .unauthorized:
                  print("Error: Unauthorized; User doesn't have permission to access file")
                case .cancelled:
                  print("Error: Cancelled; User cancelled the task")
                case .quotaExceeded	:
                  print("Error: free quota is exceeded; You have to upgrade to Blaze Plan.")
                case .unknown:
                  print("Error: Unknown; Network connection error")

                // Other possible errors
                case .bucketNotFound:
                  print("Error: bucketNotFound")
                case .downloadSizeExceeded:
                  print("Error: downloadSizeExceeded; ")
                case .invalidArgument:
                  print("Error: invalidArgument;")
                case .nonMatchingChecksum:
                  print("Error: nonMatchingChecksum;")
                case .objectNotFound:
                  print("Error: ObjectNotFound; File doesn't exist")
                case .projectNotFound:
                  print("Error: projectNotFound;")
                case .retryLimitExceeded:
                  print("Error: retryLimitExceeded;")
               default:
                  print("Error: some other error occured")
              }
        }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

