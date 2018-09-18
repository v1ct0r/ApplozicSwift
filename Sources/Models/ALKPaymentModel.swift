//
//  ALKPaymentModel.swift
//  ApplozicSwift
//
//  Created by Sunil on 16/01/18.
//

import Foundation


open class ALKPaymentModel: NSObject{
    
    open var usersRequested: NSMutableArray?

    open var userId: String?
    open var groupId: NSNumber?
    open var messageKey: String?
    
    open var launchPaymentPage: Bool = false
    open var paymentId: String?
    open var parentMessageKey: String?
    open var parentPaymentId: String?

    /// Text to display.
    open var paymentType: String?

    open var paymentAmount: String?

    open var paymentSubject: String?

    open var cancelFlag: Bool = false
    
    func toDictionary() -> [String: Any] {
        return [
            "usersRequested": usersRequested ?? [],
            "userId": userId ?? "",
            "groupId": groupId ?? "",
            "messageKey": messageKey ?? "",
            "launchPaymentPage": launchPaymentPage,
            "paymentId": paymentId ?? "",
            "parentMessageKey": parentMessageKey ?? "",
            "parentPaymentId": parentPaymentId ?? "",
            "paymentType": paymentType ?? "",
            "paymentAmount": paymentAmount ?? "",
            "paymentSubject": paymentSubject ?? "",
            "cancelFlag": cancelFlag
        ]
    }
    
}
