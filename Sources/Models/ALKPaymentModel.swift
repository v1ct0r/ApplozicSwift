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
    func toString() -> String {
        var model = "{\"paymentType\": \""
        model += paymentType ?? ""
        model += "\""
        model += ", \"launchPaymentPage\": \""
        model += String(describing: launchPaymentPage)
        model += "\""
        model += ", \"cancelFlag\": \""
        model += String(describing: cancelFlag)
        model += "\""
        if let groupID = groupId as? Int{
            let groupIDString = String(groupID)
            model += ", \"groupId\": \""
            model += groupIDString
            model += "\""
        }
        if let userID = userId {
            model += ", \"userId\": \""
            model += userID
            model += "\""
        }
        if usersRequested != nil {
            model += ", \"userRequested\": ["
            model += "\""
            model += usersRequested?[0] as! String
            model += "\""
            for i in (1..<usersRequested!.count) {
                model += ",\""
                model += usersRequested?[i] as! String
                model += "\""
            }
            model += "]"
        }
        if messageKey != nil {
            model += ", \"messageKey\": \""
            model += messageKey ?? ""
            model += "\""
        }
        if parentMessageKey != nil {
            model += ", \"parentMessageKey\": \""
            model += parentMessageKey ?? ""
            model += "\""
        }
        if parentPaymentId != nil {
            model += ", \"parentPaymentId\": \""
            model += parentPaymentId ?? ""
            model += "\""
        }
        if paymentId != nil {
            model += ", \"paymentId\": \""
            model += paymentId ?? ""
            model += "\""
        }
        if paymentAmount != nil {
            model += ", \"paymentAmount\": \""
            model += paymentAmount ?? ""
            model += "\""
        }
        if paymentSubject != nil {
            model += ", \"paymentSubject\": \""
            model += paymentSubject ?? ""
            model += "\""
        }
        model += "}"
        return model
    }
    func toDictionary() -> [String: Any] {
        return [
            "userRequested": usersRequested ?? [],
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
