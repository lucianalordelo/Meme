//
//  ViewController.swift
//  babymeme
//
//  Created by Luciana Lordelo Nascimento on 29/08/2018.
//  Copyright © 2018 Luciana Lordelo Nascimento. All rights reserved.
//

import UIKit

class CreateMemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK 1: Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var takePictureButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    var TextDelegate = TopBottomTextFieldDelegate()
    
    //MARK 2: Textfield Specifications
    override func viewDidLoad() {
        super.viewDidLoad()
        configureText(topTextField)
        configureText(bottomTextField)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (cancelMeme(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector (share(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureText(_ textField: UITextField) {
        textField.delegate = TextDelegate
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -4]
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    
    // MARK 3: Device camera verification & KeyBoard Subscription
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        takePictureButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK 4: IBActions
    
    //Take an image button
    @IBAction func takeAnImage(_ sender: Any) {
        presentImagePicker(.camera)
    }
    
    //Pick an image button
    @IBAction func pickAnImage(_ sender: Any) {
        presentImagePicker(.photoLibrary)
    }
    
    func presentImagePicker (_ sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present (pickerController,animated: true, completion: nil)
    }
    
    @objc func cancelMeme(_ sender: Any) {
        topTextField.text = ""
        bottomTextField.text = ""
        imagePickerView.image = nil
        navigationController?.popViewController(animated: true)
    }
    
    @objc func share(_ sender: Any) {
        let image = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present (activityController,animated: true, completion: nil)
        activityController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.save(image)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    //save method used by share method
    func save(_ memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalimage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func hideTopAndBottomBar (_ hide: Bool) {
        toolbar.isHidden = hide
    }
    
    //a way to render view to an image
    func generateMemedImage() -> UIImage {
        hideTopAndBottomBar(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideTopAndBottomBar(false)
        return memedImage
    }
    
    //MARK 5: Keyboard subscription & unsubcription to notify when user is typing and slide the view
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //this method calculates the height of the keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //slides the view up (keyboard height) if bottomTextField is being used
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = 0
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}



