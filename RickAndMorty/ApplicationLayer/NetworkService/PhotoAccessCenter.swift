//
//  PhotoAccessCenter.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 21.12.2023.
//


import UIKit
import Photos

class PhotoAccessCenter {
    
    static func checkLibraryAuthentication(in controller: UIViewController, completion: (() -> ())?) {
        let status: PHAuthorizationStatus
        
        status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
       
        
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                completion?()
            }
        case .denied, .restricted :
            DispatchQueue.main.async {
                showAlertAuthError(in: controller,
                                   withTitle: "Нет доступа к медиатеке",
                                   withMessage: "Пожалуйста предоставьте доступ к медиатеке")
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { newStatus in
                DispatchQueue.main.async {
                    PhotoAccessCenter.checkLibraryAuthentication(in: controller) {
                        completion?()
                    }
                }
            }
    
        default: return
        }
    }
    
    static func checkCameraAuthentication(in controller: UIViewController, completion: @escaping () -> ()) {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showAlertAuthError(in: controller,
                                        withTitle: "Нет доступа к камере",
                                        withMessage: "Пожалуйста предоставьте доступ к камере")
            }
        case .authorized:
            DispatchQueue.main.async {
                completion()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    
                    DispatchQueue.main.async {
                        PhotoAccessCenter.checkCameraAuthentication(in: controller) {
                            completion()
                        }
                    }
                }
            }
        default: return
        }
    }
    
    private static func showAlertAuthError(in controller: UIViewController,
                                           withTitle title: String,
                                           withMessage message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) in
            let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        controller.present(alertController, animated: true)
    }
}
