//
//  ALKPaymentStatus.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 24/09/18.
//

import Foundation

open class ALKPaymentStatus{
    open var code : String?
    open var paymentStatus: String?
    open var messageKey: String?
    open var parentMessageKey: String?
    open var parentPaymentId: String?
    open var paymentId: String?
    open var error: String?
    
    func toString() -> String {
        var status = "{\"paymentStatus\": \""
        status += paymentStatus ?? ""
        status += "\""
        
        if code != nil {
            status += ", \"code\": \""
            status += code ?? ""
            status += "\""
        }
        if messageKey != nil {
            status += ", \"messageKey\": \""
            status += messageKey ?? ""
            status += "\""
        }
        if parentMessageKey != nil {
            status += ", \"parentMessageKey\": \""
            status += parentMessageKey ?? ""
            status += "\""
        }
        if parentPaymentId != nil {
            status += ", \"parentPaymentId\": \""
            status += parentPaymentId ?? ""
            status += "\""
        }
        if paymentId != nil {
            status += ", \"paymentId\": \""
            status += paymentId ?? ""
            status += "\""
        }
        if error != nil {
            status += ", \"error\": \""
            status += error ?? ""
            status += "\""
        }
        
        status += "}"
        return status
    }
}
