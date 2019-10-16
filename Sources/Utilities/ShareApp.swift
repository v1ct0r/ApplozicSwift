//
//  ShareApp.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 17/09/18.
//

import Foundation

class ShareApp: NSObject, UIActivityItemSource {
    
    var messageToBeShared: String = ""
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return messageToBeShared
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if(activityType == UIActivity.ActivityType.mail){
            return messageToBeShared
        } else if(activityType == UIActivity.ActivityType.postToTwitter){
            return messageToBeShared
        } else {
            return messageToBeShared
        }
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        
        if(activityType == UIActivity.ActivityType.mail){
            return "Hey check this out!!"
        } else if(activityType == UIActivity.ActivityType.postToTwitter){
            return messageToBeShared
        } else {
            return messageToBeShared 
        }
    }
    
}
