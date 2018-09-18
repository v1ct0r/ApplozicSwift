//
//  BroadcastToIonic.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 17/09/18.
//

import Foundation

class BroadcastToIonic {

    class func sendBroadcast(name: String, data: [AnyHashable: Any]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil, userInfo: data)
    }

}
