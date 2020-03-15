//
//  PermissionController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/20/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class PermissionController: PermissionsViewController {

    @IBOutlet weak var btnLoation: RadioButton!
    
    @IBOutlet weak var btnCamera: RadioButton!
    
    @IBOutlet weak var btnMicrophone: RadioButton!
    
    @IBOutlet weak var btnNotification: RadioButton!
    
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnHeight.constant = Constant.BTN_HEIGHT
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func checkAllPermissions() {
        if btnLoation.checked && btnCamera.checked && btnMicrophone.checked && btnNotification.checked {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Utilities.goToHomeScreen()
            }
        }
    }
    
    // Mark -- Action Defines
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locationAction(_ sender: Any) {
        self.didTapLocationButton()
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        self.didTapCameraButton()
    }
    
    @IBAction func microphoneAction(_ sender: Any) {
        self.didTapMicrophoneButton()
    }
    
    @IBAction func pushNotificationAction(_ sender: Any) {
        self.didTapPushNotification()
    }
    
    override func updateLocationButton(_ isEnabled: Bool) {
        btnLoation.setChecked(isEnabled)
        checkAllPermissions()

    }
    
    override func updateCameraButton(_ isEnabled: Bool) {
        btnCamera.setChecked(isEnabled)
        checkAllPermissions()

    }
    
    override func updateMicrophoneButton(_ isEnabled: Bool) {
        btnMicrophone.setChecked(isEnabled)
        checkAllPermissions()

    }
    
    override func updateNotificationButton(_ isEnabled: Bool) {
        btnNotification.setChecked(isEnabled)
        checkAllPermissions()
    }
}
