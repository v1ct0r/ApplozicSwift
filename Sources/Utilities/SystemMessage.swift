//
//  SystemMessage.swift
//  ApplozicSwift
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import Foundation
import Foundation

//handle all in app's display messages
struct SystemMessage {
    
    struct Camera {
        static let cameraPermission = Localization.localizedString(forKey: "EnableCameraPermissionMessage")
        static let CamNotAvailable = Localization.localizedString(forKey: "CameraNotAvailableMessage")
        static let camNotAvailableTitle = Localization.localizedString(forKey: "CameraNotAvailableTitle")
        static let GalleryAvailable = Localization.localizedString(forKey: "GalleryNotAvailableMessage")
        static let PictureCropped = Localization.localizedString(forKey: "ImageCroppedMessage")
        static let PictureReset = Localization.localizedString(forKey: "ImageResetMessage")
        static let PleaseAllowCamera = Localization.localizedString(forKey: "PleaseAllowCamera")
    }
    
    struct Microphone {
        static let MicNotAvailable = Localization.localizedString(forKey: "MicrophoneNotAvailableMessage")
        static let PleaseAllowMic = Localization.localizedString(forKey: "AllowSoundRecordingMessage")
        static let SlideToCancel = Localization.localizedString(forKey: "SlideToCancelMessage")
        static let Recording = Localization.localizedString(forKey: "RecordingMessage")
        static let HoldToTalkMessage = Localization.localizedString(forKey: "HoldToTalkMessage")
        static let RecordingMessageStarting = Localization.localizedString(forKey: "RecordingMessageStarting")
        static let RecordingMessageProgress = Localization.localizedString(forKey: "RecordingMessageProgress")
    }
    
    struct Map {
        static let NoGPS = Localization.localizedString(forKey: "TurnGPSOnMessage")
        static let MapIsLoading = Localization.localizedString(forKey: "MapLoadingMessage")
        static let AllowPermission = Localization.localizedString(forKey: "AllowGPSMessage")
        static let TurnOnLocationService = Localization.localizedString(forKey: "TurnOnLocationService")
        static let LocationAlertMessage = Localization.localizedString(forKey: "LocationAlertMessage")
    }
    
    struct Information {
        static let FriendAdded = Localization.localizedString(forKey: "FriendAddedMessage")
        static let FriendRemoved = Localization.localizedString(forKey: "FriendRemovedMessage")
        static let AppName = ""
        static let ChatHere = Localization.localizedString(forKey: "ChatHere")
    }
    
    struct Update {
        static let CheckRequiredField = Localization.localizedString(forKey: "CheckImageAndNameField")
        static let UpdateMood = Localization.localizedString(forKey: "UpdateMoodMessage")
        static let UpdateProfileName = Localization.localizedString(forKey: "UpdateProfileSuccessMessage")
        static let Failed = Localization.localizedString(forKey: "FailedToUpdateMessage")
    }
    
    struct Warning {
        static let NoEmail = Localization.localizedString(forKey: "EnterEmailMessage")
        static let InvalidEmail = Localization.localizedString(forKey: "InvalidEmailMessage")
        static let FillInAllFields = Localization.localizedString(forKey: "Please fill-in all fields")
        static let FillInPassword = Localization.localizedString(forKey: "FillPasswordMessage")
        static let PasswordNotMatched = Localization.localizedString(forKey: "PasswordNotMatchedMessage")
        static let CamNotAvaiable = Localization.localizedString(forKey: "CamNotAvaiable")
        static let Cancelled = Localization.localizedString(forKey: "CancelMessage")
        static let PleaseTryAgain = Localization.localizedString(forKey: "ConnectionFailedMessage")
        static let FetchFail = Localization.localizedString(forKey: "FetchFailedMessage")
        static let OperationFail = Localization.localizedString(forKey: "OperationFailedMessage")
        static let DeleteSingleConversation = Localization.localizedString(forKey: "DeleteSingleConversation")
        static let LeaveGroupConoversation = Localization.localizedString(forKey: "LeaveGroupConversation")
        static let DeleteGroupConversation = Localization.localizedString(forKey: "DeleteGroupConversation")
        static let DeleteContactWith = Localization.localizedString(forKey: "RemoveMessage")
        static let DownloadOriginalImageFail = Localization.localizedString(forKey: "DownloadOriginalImageFail")
        static let ImageBeingUploaded = Localization.localizedString(forKey: "UploadingImageMessage")
        static let SignOut = Localization.localizedString(forKey: "SignOutMessage")
        static let FillGroupName = Localization.localizedString(forKey: "FillGroupName")
        static let DiscardChange = Localization.localizedString(forKey: "DiscardChangeMessage")
    }
    
    struct ButtonName {
        static let SignOut = Localization.localizedString(forKey: "SignOutButtonName")
        static let Retry = Localization.localizedString(forKey: "RetryButtonName")
        static let Remove = Localization.localizedString(forKey: "RemoveButtonName")
        static let Leave = Localization.localizedString(forKey: "LeaveButtonName")
        static let Cancel = Localization.localizedString(forKey: "ButtonCancel")
        static let Discard = Localization.localizedString(forKey: "ButtonDiscard")
        static let Save = Localization.localizedString(forKey: "SaveButtonTitle")
        static let ResetPhoto = Localization.localizedString(forKey: "ResetPhotoButton")
        static let Select = Localization.localizedString(forKey: "SelectButton")
        static let Done = Localization.localizedString(forKey: "DoneButton")
        static let Invite = Localization.localizedString(forKey: "InviteButton")
    }
    
    struct NoData {
        static let NoName = Localization.localizedString(forKey: "NoNameMessage")
    }
    
    struct UIError {
        static let unspecifiedLocation = Localization.localizedString(forKey: "UnspecifiedLocation")
    }
    
    struct PhotoAlbum {
        static let Success  = Localization.localizedString(forKey: "PhotoAlbumSuccess")
        static let Fail     = Localization.localizedString(forKey: "PhotoAlbumFail")
        static let SuccessTitle = Localization.localizedString(forKey: "PhotoAlbumSuccessTitle")
        static let FailureTitle = Localization.localizedString(forKey: "PhotoAlbumFailureTitle")
        static let Ok = Localization.localizedString(forKey: "PhotoAlbumOk")
    }
    
    struct Message {
        static let isTypingForRTL = Localization.localizedString(forKey: "IsTypingForRTL")
        static let isTyping = Localization.localizedString(forKey: "IsTyping")
        static let areTyping = Localization.localizedString(forKey: "AreTyping")
    }
    
    struct ChatList {
        static let title = Localization.localizedString(forKey: "ConversationListVCTitle")
        static let leftBarBackButton = Localization.localizedString(forKey: "Back")
    }
    
    struct Chat {
        static let somebody = Localization.localizedString(forKey: "Somebody")
    }
    
    struct NavbarTitle {
        static let createGroupTitle = Localization.localizedString(forKey: "CreateGroupTitle")
        static let editGroupTitle = Localization.localizedString(forKey: "EditGroupTitle")
        static let contactTitle = Localization.localizedString(forKey: "ContactList")
        static let registeredContacts = Localization.localizedString(forKey: "RegisteredContacts")
        static let unregisteredContacts = Localization.localizedString(forKey: "UnregisteredContacts")
    }
    
    struct LabelName {
        static let Edit = Localization.localizedString(forKey: "Edit")
        static let Participants = Localization.localizedString(forKey: "Participants")
        static let TypeGroupName = Localization.localizedString(forKey: "TypeGroupName")
        static let SendPhoto = Localization.localizedString(forKey: "SendPhoto")
        static let Settings = Localization.localizedString(forKey: "Settings")
        static let Camera = Localization.localizedString(forKey: "Camera")
        static let Cancel = Localization.localizedString(forKey: "Cancel")
        static let CropImage = Localization.localizedString(forKey: "CropImage")
        static let Photos = Localization.localizedString(forKey: "PhotosTitle")
        static let SendVideo = Localization.localizedString(forKey: "SendVideo")
        static let SearchPlaceholder = Localization.localizedString(forKey: "SearchPlaceholder")
        static let NewChatTitle = Localization.localizedString(forKey: "NewChatTitle")
        static let AddToGroupTitle = Localization.localizedString(forKey: "AddToGroupTitle")
        static let InviteMessage = Localization.localizedString(forKey: "InviteMessage")
        static let DiscardChangeTitle = Localization.localizedString(forKey: "DiscardChangeTitle")
        static let NotNow = Localization.localizedString(forKey: "NotNow")
        static let Copy = Localization.localizedString(forKey: "Copy")
        static let Reply = Localization.localizedString(forKey: "Reply")
        static let You = Localization.localizedString(forKey: "You")
    }
    
    struct ShareApp {
        static let message = Localization.localizedString(forKey: "ShareAppMessage")
    }
    
    struct PaymentUsers {
        static let PaymentUsersTitle = Localization.localizedString(forKey: "PaymentUsersTitle")
        static let AddUsers = Localization.localizedString(forKey: "AddUsers")
        static let SendPaymentButton = Localization.localizedString(forKey: "SendPaymentButton")
        static let RequestPaymentButton = Localization.localizedString(forKey: "RequestPaymentButton")
    }
    
    struct PaymentPopup {
        static let title = Localization.localizedString(forKey: "GroupPaymentPopupTitle")
        static let message = Localization.localizedString(forKey: "GroupPaymentPopupMessage")
        static let acceptButton = Localization.localizedString(forKey: "GroupPaymentPopupAcceptButton")
        static let rejectButton = Localization.localizedString(forKey: "GroupPaymentPopupRejectButton")
        static let Todos = Localization.localizedString(forKey: "Todos")
    }
    
    struct PaymentMessage {
        static let Asunto = Localization.localizedString(forKey: "Asunto")
        static let Re = Localization.localizedString(forKey: "Re")
        static let AcceptPayment = Localization.localizedString(forKey: "AcceptPayment")
        static let RefusePayment = Localization.localizedString(forKey: "RefusePayment")
        static let RequestedFrom = Localization.localizedString(forKey: "RequestedFrom")
        static let Paid = Localization.localizedString(forKey: "Paid")
        static let Rejected = Localization.localizedString(forKey: "Rejected")
        static let RejectedYours = Localization.localizedString(forKey: "RejectedYours")
        static let SomeoneRejected = Localization.localizedString(forKey: "SomeoneRejected")
        static let YouAccepted = Localization.localizedString(forKey: "YouAccepted")
    }
}
