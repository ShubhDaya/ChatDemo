//
//  ViewController.swift
//  FireBaseDemo
//
//  Created by IOS-Shubham-40 on 31/03/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    @IBOutlet weak var txtchat: UITextField!
    @IBOutlet weak var imgSendImg: UIImageView!
    
    var localImagePath:String = ""
    let imagePicker = UIImagePickerController()
        
    var storageRef: StorageReference!
    var imgUrl = ""
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle?
    var newMessageRefHandle: DatabaseHandle?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.imagePicker.delegate = self
        self.configureStorage()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnSendMessage(_ sender: Any) {
        self.writeDataOnFirebaseForChatNew()
        
    }
    
    @IBAction func btnSelectImage(_ sender: Any) {
        
        let alert:UIAlertController = UIAlertController(title: "Choose_Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            objAppShareData.checkCameraPermissions(handler: { [weak self](isGranted) in
                guard let strongSelf = self else{return}
                if isGranted{
                    strongSelf.openCamera()
                }
            })
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            objAppShareData.checkCameraPermissions(handler: { [weak self](isGranted) in
                guard let strongSelf = self else{return}
                if isGranted{
                    strongSelf.openGallary()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureStorage() {
        
        ref =  Database.database().reference()
        storageRef = Storage.storage().reference().child("chat_photos")
    }
}

//MARK: - Send text data to firebase
extension ViewController{
    
    func writeDataOnFirebaseForChatNew(){
        
        let calendarDate = ServerValue.timestamp()
        
        let dictOrder = [
            "image":0,
            "image_url":  "",
            "msg_read_tick":0,
            "message":txtchat.text,
            "timestamp":calendarDate,
           // "reference _id": self.strReferenceID ,
            //"order_Id_ride_id": self.strOrderRideId ,
            "msg_sender_id": "1"
        ] as [String : Any]
        let dictOther = [
            "value":0,
            ] as [String : Any]
        
        print(dictOrder)
        self.ref.child("chat").child("2-1").child("messages").childByAutoId().setValue(dictOrder)
    
    }
}
//MARK: - imagePicker extension method
extension ViewController{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        
        var img : UIImage?
        if let image = info[.editedImage] as? UIImage {
            
            img = image
           // self.strTextNotification = "Sent an image"
            if let url = info[.referenceURL] as? NSURL {
                
                self.localImagePath = url.absoluteString ?? ""
            }
        }

        
        if let Image = img {
          //  self.strTextNotification = "Sent an image"
           // imgZoomImage.image = Image
            
            self.uploadImageToFirebaseStorage(image: Image) { [weak self](firebaseImageUrl) in
                guard let weakSelf = self else{return}
                weakSelf.sendImageWithFirebaseURL(strLocalFileUrl: firebaseImageUrl)
            }
        }
        UIApplication.shared.endIgnoringInteractionEvents()

      //  objAppShareData.isOnChatScreen = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
      //  self.viewZoomImg.isHidden = true
        picker.dismiss(animated: false, completion: nil)
        print("picker cancel.")
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    func openGallary(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
}
//MARK: - send image on firebase
extension ViewController{
    
    func uploadImageToFirebaseStorage(image : UIImage, completion:@escaping (String)->Void){
      //  objWebServiceManager.StartIndicator()
               
       let imageData = self.compressImage(image: image) as Data?
        let localFilePath = "\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let upload_metadata = StorageMetadata()
        upload_metadata.contentType = "image/jpeg"
        let storageImage = self.storageRef.child(localFilePath)
        storageImage.putData(imageData!, metadata: upload_metadata) { [weak self] (download_metadata, error) in
            storageImage.downloadURL { (url, error) in
                self?.view.endEditing(true)
                let downloadURL = url
                self!.imgUrl = downloadURL!.absoluteString
                //  print(">> imgUrl =  \(self!.imgUrl)")
                completion((self?.imgUrl)!)
            }
        }
    }
    
    func sendImageWithFirebaseURL(strLocalFileUrl: String) {
      //  objWebServiceManager.StartIndicator() // new
        let calendarDate = ServerValue.timestamp()
        
        let dictOrder = [
            "image":1,
            "image_url":  strLocalFileUrl,
            "msg_read_tick":0,
            "message":"",
            "timestamp":calendarDate,
            "reference _id": "" ,
            "order_Id_ride_id": "" ,
            "msg_sender_id": "" ] as [String : Any]
        
        let dictOther = [
            "value":0,
            ] as [String : Any]
            
            as [String : Any]
        
        print(dictOrder)
        
        self.ref = Database.database().reference()
        
        let Key12 = self.ref.child("chat").childByAutoId()
        let childautoID12 =  Key12.key!
        
        ref.child("chat").child("messages").child(childautoID12).setValue(dictOrder)
       // ref.child("chat").child(self.strChatRoom).child("other").child(childautoID12).setValue(dictOther)
      //  ref.child("chat").child(self.strChatRoom).child("other").setValue(dictOther)

        UIApplication.shared.endIgnoringInteractionEvents()

    }
}
//MARK: - Compess image resize
extension ViewController{
    
    func compressImage(image:UIImage) -> Data? {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1600.0
        let maxWidth : CGFloat = 1000.0
        let minHeight : CGFloat = 150.0
        let minWidth : CGFloat = 150.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        let minRatio : CGFloat = minWidth/minHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        if (actualHeight < minHeight || actualWidth < minWidth){
            if(imgRatio > minRatio){
                //adjust width according to maxHeight
                imgRatio = minHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = minHeight
            }
            else if(imgRatio < minRatio){
                //adjust height according to maxWidth
                imgRatio = minWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = minWidth
            }
            else{
                actualHeight = minHeight
                actualWidth = minWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = img.jpegData(compressionQuality:0.75) else{
            return nil
        }
        return imageData
    }
}
