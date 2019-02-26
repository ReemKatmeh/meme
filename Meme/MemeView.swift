//
//  ViewController.swift
//  Meme
//
//  Created by Reem Katmeh on 15/12/2018.
//  Copyright © 2018 reemkt. All rights reserved.
//

import UIKit
class MemeView: UIViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var buttomText: UITextField!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    let picker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = imagePickerView.image != nil
        setupTextFields(topText, with: "TOP")
        setupTextFields(buttomText, with: "BOTTOM")
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    
    
    // setup text fields

    func setupTextFields(_ textField: UITextField, with default: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] =
            [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSAttributedString.Key.strokeWidth: -4.0
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    
    
 // keyboard functions
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if buttomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }}
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y = 0
    }
    
func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeView.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification  , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeView.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
//        NotificationCenter.default.removeObserver(self)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    //text functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.text == "TOPTEXT" || textField.text == "BOTTOMTEXT") {
            textField.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != "") { return true }
        
        if self.topText.isFirstResponder {
            textField.text = "TOP"
        }
        else {
            textField.text = "BOTTOM"
        }
        return true
    }
    
    
    
    //image functions
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        picker.sourceType = sourceType
        self.present(picker, animated: true, completion: nil)
        
    }

    @IBAction func PickfromAlbum(_ sender: Any) {
        
        pickAnImage(sourceType: .photoLibrary)
        
    }
    
    
    @IBAction func pickFromCamera(_ sender: Any) {

        pickAnImage(sourceType: .camera)

    }
    
    
    
    //image Picker controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
    
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? info[UIImagePickerController.InfoKey.originalImage] as? UIImage
              imagePickerView.image = image
                shareButton.isEnabled = true
        
            dismiss(animated: true, completion: nil)
            }
    
    
    
    //cancel
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        
        if let navigationController = navigationController {
            print("navigating back")
            navigationController.popToRootViewController(animated: true)
            dismiss(animated: true, completion: nil)
            
        imagePickerView.image = nil
        shareButton.isEnabled = false
        cancelButton.isEnabled = true
        topText.text = nil
        buttomText.text = nil
       imagePickerView.image = nil
        
         
        }}
    
    
    
    
     // generate image
    
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        //navigationBar.isHidden = true

        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
       //navigationBar.isHidden = false

        return memedImage
    }
    
  
    
    // save meme
    
    func save() {
        
        let memedImage = generateMemedImage()
        // Create the meme
        let meme = Meme(topText: topText.text!,
                        bottomText: buttomText.text!,
                        originalImage: imagePickerView.image!,
                        memedImage: memedImage)
         // Add it to the memes array in the Application Delegate

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func shareImage(_ sender: Any) {
        
        let image = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = {
            activityType, completed, returenedItems, activityError in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }

}

}
