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
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        if(activityType == UIActivityType.mail){
            return messageToBeShared
        } else if(activityType == UIActivityType.postToTwitter){
            return messageToBeShared
        } else {
            return messageToBeShared
        }
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        
        if(activityType == UIActivityType.mail){
            return "Hey check this out!!"
        } else if(activityType == UIActivityType.postToTwitter){
            return messageToBeShared
        } else {
            return messageToBeShared 
        }
    }
    
}
