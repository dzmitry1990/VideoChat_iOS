//
//  EditProfileController.swift
//  Ghost
//
//  Created by Dzmitry Zhuk on 5/27/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class EditProfileController: BaseViewController {

    @IBOutlet weak var ivUser: UIImageView! 
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ivUser.layoutIfNeeded()
        ivUser.layer.cornerRadius = ivUser.bounds.height / 2

        for txt in [txtFirst, txtLast] {
            txt?.delegate = self
        }
        
        let path = Preferences.sharedInstance.thumbnailPath
        if !path.isEmpty {
            ivUser.sd_setImage(with: URL(string: path))
        }
        
        txtFirst.text = Preferences.sharedInstance.firstName
        txtLast.text = Preferences.sharedInstance.lastName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        guard let firstname = txtFirst.text, !firstname.isEmpty else {
            self.showAlertWithErrorMessage("Please input your first name.")
            return
        }
        
        guard let lastname = txtLast.text, !lastname.isEmpty else {
            self.showAlertWithErrorMessage("Please input your last name.")
            return
        }
        
        updateProfile(firstname, lastname: lastname)
    }
    
    
    @IBAction func changeImageAction(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: Utilities.isPad() ? .alert : .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "From photo library", style: .default, handler: { (action) in
            self.openLibrary()
        }))
        alertController.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    fileprivate func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
}

extension EditProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirst {
            txtLast.becomeFirstResponder()
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.dismiss(animated: true, completion: nil);
        
        ivUser.image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil);
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ivUser.image = chosenImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil);
    }
    
}

extension EditProfileController {
    fileprivate func updateProfile(_ firstname: String, lastname: String) {
        self.loadingIndicator.visibility = true
        HttpHelper.uploadPhoto(ivUser.image!, firstname: firstname, lastname: lastname) { (userPath, error) in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility  = false
                
                
                if let userPath = userPath {
                    Preferences.sharedInstance.setThumbnailPath(userPath)
                    Preferences.sharedInstance.setFirstName(firstname)
                    Preferences.sharedInstance.setLastName(lastname)
                    self.showAlert(with: "Success", message: "Profile updated", handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    
                    if let error = error {
                        self.showAlertWithError(error)
                        return
                    }
                    
                    self.showAlertWithErrorMessage("Failed, try later.")
                }
            }
            
            
        }
        
    }
}

