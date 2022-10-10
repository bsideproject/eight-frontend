//
//  ImagePickerManager.swift
//  EightFront
//
//  Created by wargi on 2022/10/10.
//

import UIKit
import Toast

final class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    enum Picker {
        case camera
        case album
    }
    private override init() {}
    static var shared = ImagePickerManager()
    private var picker = UIImagePickerController()
    private var pickImageCallback : ((UIImage) -> ())?
    
    func pickImageWithAlert(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        let alert = UIAlertController(title: "사진 선택", message: nil, preferredStyle: .actionSheet)
        pickImageCallback = callback
        picker.delegate = self
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.openCamera(viewController)
        }
        let galleryAction = UIAlertAction(title: "앨범", style: .default) { _ in
            self.openGallery(viewController)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = viewController.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(_ viewController: UIViewController, _ callback: ((UIImage) -> ())? = nil) {
        picker.delegate = self
        if let callback = callback { pickImageCallback = callback }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            viewController.present(picker, animated: true, completion: nil)
        } else {
            viewController.view.makeToast("카메라를 사용할 수 없습니다.")
        }
    }
    
    func openGallery(_ viewController: UIViewController, _ callback: ((UIImage) -> ())? = nil) {
        picker.delegate = self
        if let callback = callback { pickImageCallback = callback }
        
        picker.sourceType = .photoLibrary
        viewController.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true) { [weak self] in
                guard let image = info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
                self?.pickImageCallback?(image)
                self?.pickImageCallback = nil
            }
        }
    }
}
