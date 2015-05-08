//
//  MemeEditorViewController.swift
//  mmTest
//
//  Created by William Song on 4/27/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    var memes = [Meme]()
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : NSNumber(float: -4.0),
        
    ]
    
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
        cancelButton.enabled = false
        textFieldDefalults(topTextField)
        textFieldDefalults(bottomTextField)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    func textFieldDefalults(textField: UITextField){
        //set textfield defualts
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }
    @IBAction func canelImage(sender: AnyObject) {
        confirm()
    }
    func confirm() {
        //comfirm user if really want to cancel
        var refreshAlert = UIAlertController(title: "Alert", message: "Selected data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(true, completion: {});
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
          //stay put
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }

    @IBAction func shareImage(sender: AnyObject) {
        //calling stock function with activityview controller, save selection image and sent user to sent meme view
        let textToShare = "Swift is awesome!  Check out this awesome picture I editted!"
       
        let mmImage = generateMemedImage()
        
        let objectsToShare = [textToShare,  mmImage]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(activityVC, animated: true, completion: nil)

       directToSentMeme()
        
    }
    @IBAction func chooseFromAlbum(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true,completion: nil)
    }
    
    
    @IBAction func chooseFromCamera(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true,completion: nil)
        
    }
    //calling imagepickcontroller, select image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            shareButton.enabled = true
            cancelButton.enabled = true
        }
    }
    
    //keyboard management routines
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:") , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
       // }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0 //getKeyboardHeight(notification)
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //get keybord height
        let userInfo = notification.userInfo
       let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        if bottomTextField.editing{
            return keyboardSize.CGRectValue().height
        }
        else{
            return 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //return textfield
        textField.resignFirstResponder()
        return true
    }
    
    func directToSentMeme() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TableView") as! UIViewController!

        presentViewController(vc, animated: true, completion: nil)
    }
    
    func save() {
        //Create the meme
        var meme = Meme(topText: topTextField.text,  bottomText: topTextField.text,
            orginalImage: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topBar.hidden = true
        bottomBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //  Show toolbar and navbar
        topBar.hidden = false
        bottomBar.hidden = false
        
        return memedImage
    }

}

