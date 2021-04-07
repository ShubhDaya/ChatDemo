//
//  AppShareData.swift
//  FireBaseDemo
//
//  Created by IOS-Shubham-40 on 31/03/21.
//

import Foundation

import UIKit

import Firebase
import Foundation
import AVFoundation
import AVKit
import Photos
import FirebaseStorage
import FirebaseDatabase


let objAppShareData : AppShareData  = AppShareData.sharedObject()


class AppShareData: NSObject{
    
    var backgroundColor: UIColor?
    var fromPasswordreminder = false
    
    var successBlock : ((_ placeInfo: [String: Any])->())?
    var failureBlock : ((_ error: Error)->())?
    var controller: UIViewController?
    var imagePicker = UIImagePickerController()
    var isDriverProfile = false
    var isFromPayment = false
    var isFromZoom = false
    var isFromFilter = false
    var isFromPlacePicker = false
    var isFromCartList = false
    var isFromWallet = false
    var isFromSelectAddress = false
    var isOnChatScreen = false
    var isFromObserverCalled = false
    var isOnMapScreen = false
    var isOnDriverProfileScreen = false
    var isUpcomingDetailScreen = false
    
    var isUpcomingList = false // deepak new testing
    
    var strCardId = ""
    var strPaymentMethod = ""
    var dictUserLoction = [String:Any]()
    var dictRideLoction = [String:Any]()
    var dictVichleInfo = [String:Any]()
    
    var strSelectedVehicleCompanyId : String = ""
    var strSelectedVehicleMetaId : String = ""
    var strSelectedCompanyNames : String = ""
    var strSelectedModelNames : String = ""
    var arrSelectedBusinessId = [Int]()
    var arrSelectedCategoryId = [Int]()
    var arrSelectedLanguageId = [Int]()
    var arrSelectedLanguageName = [String]()
    
 
    
    var isFromBannerNotification = false
    var strBannerNotificationType = ""
    var strBannerReferenceType = ""
    var strBannerReferenceID = ""
    var strBannerCurrentStatus = ""
    var strBannerChatRoom = ""
    var notificationBannerDict = [:] as? [String:Any]
    
    var opponentUserId = ""
    var ref: DatabaseReference?
    var refff: DatabaseReference!
    var strChatUnreadCount = 0
    var strAppIconCount = 0
    
    //MARK: - Shared object
    
    private static var sharedManager: AppShareData = {
        let manager = AppShareData()
        return manager
    }()
    
    // MARK: - Accessors
    class func sharedObject() -> AppShareData {
        return sharedManager
    }
    
    
    //MARK:- checkCameraPermissions
    func checkCameraPermissions(handler:(Bool)->Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            print("Allowed")
            handler(true)
        case .denied:
            handler(false)
            alertPromptToAllowCameraAccessViaSetting()
        default:
            print("Allowed")
            handler(true)
        }
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Camera access required", message: "Camera access is disabled please allow from Settings.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (alert) -> Void in
            //UIApplication.shared.openURL(URL(string: UIApplication.UIApplicationOpenSettingsURLString)!)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options:  [:], completionHandler: nil)
        })
        // alert.show()
    }
    
}
