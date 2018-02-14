//
//  ALKAmountPayController.swift
//  ApplozicSwift
//
//  Created by Sunil on 16/01/18.
//

import Foundation

import UIKit
import Applozic


class ALKAmountPayController: UIViewController,ALKCustomAmountProtocol{
    
    var delaget : ALKCustomAmountProtocol!
    public var paymentModleData :ALKPaymentModel?
    
    @IBOutlet weak var amountTextFeild: UITextField!
    @IBOutlet weak var paymentSbject: UITextField!
    @IBOutlet weak var paybutton: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    func didAcceptCliked(paymentModel:ALKPaymentModel){
        paymentModleData = paymentModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func paybutton(_ sender: AnyObject) {
        
        if(amountTextFeild.text?.isEmpty)!{
            print("amount is empty :: " , amountTextFeild)
            return;
        }else if(paymentSbject.text?.isEmpty)!{
            print("paymentSbject is empty :: " , paymentSbject)
            return;
        }
        
        let messsageService = ALMessageService();
        let messagedb = ALMessageDBService();
        
        var nsmutable = NSMutableDictionary();
        
        if( paymentModleData?.messageKey != nil){
            
            let message = messagedb.getMessage("key", value:paymentModleData?.messageKey);
            nsmutable =   (message?.metadata)!
            
            nsmutable["paymentStatus"] = "paymentAccepted"
            
            let currentTimeInMiliseconds = Int64(Date().timeIntervalSince1970 * 1000)
            
            nsmutable["paymentId"] = String(currentTimeInMiliseconds)
            
            nsmutable["hiddenStatus"] = "true"
            
            if (nsmutable["usersRequested"] != nil ) {
                nsmutable["paymentSubjectKey"]  = "Re"
                nsmutable["paymentReceiver"]  = message?.to
                nsmutable[ ALUserDefaultsHandler.getUserId()]  = "done"
                nsmutable .removeObject(forKey: "paymentHeader")
                
            }
            
            let paymentId =  nsmutable["paymentId"]
            let  paymentMessage = nsmutable["paymentMessage"]
            let  paymentSubject = nsmutable["paymentSubject"]
            let  paymentStatus = nsmutable["paymentStatus"]
            let   richMessageType = nsmutable["richMessageType"]
            
            messsageService.updateMessageMetaData(paymentModleData?.messageKey, withMessageMetaData: nsmutable,withCompletionHandler:{
                apirespone, error in
                
                if((error == nil) ){
                    
                    let dbMessage = messagedb.getMessage("key", value:self.paymentModleData?.messageKey)
                    var nsmutableMeatdata = NSMutableDictionary();
                    nsmutableMeatdata =   (dbMessage?.metadata)!
                    
                    if(nsmutableMeatdata["paymentStatus"] != nil &&  nsmutableMeatdata["paymentStatus"] as! String == "paymentAccepted"){
                        
                        nsmutableMeatdata["usersRequested"] = nil;
                        
                        let message =  ALMessage();
                        
                        if(dbMessage?.groupId != nil){
                            message.groupId = dbMessage?.groupId
                        }else if(dbMessage?.contactId != nil){
                            message.contactIds = dbMessage?.contactId
                            message.to = dbMessage?.contactId
                        }
                        
                        message.key =  UUID().uuidString
                        let date = Date().timeIntervalSince1970*1000
                        message.createdAtTime = NSNumber(value: date)
                        message.sendToDevice = false
                        message.deviceKey = ALUserDefaultsHandler.getDeviceKeyString()
                        message.shared = false
                        message.fileMeta = nil
                        message.storeOnDevice = false
                        message.contentType = Int16(ALMESSAGE_RICH_MESSAGING)
                        message.type = "5"
                        message.source = Int16(SOURCE_IOS)
                        
                        nsmutableMeatdata["paymentId"] =  nsmutableMeatdata["paymentId"]
                        
                        nsmutableMeatdata["hiddenStatus"] = "false"
                        nsmutableMeatdata["paymentStatus"] = "paymentAccepted"
                        nsmutableMeatdata["richMessageType"] = "paymentMessage"
                        message.metadata = nsmutableMeatdata
                        
                        ALMessageService.sendMessages(message, withCompletion: {
                            message, error in
                            
                            if(message != nil){
                                print("This updated now ")
                            }
                            
                        })
                        
                    }
                    
                }
            })
            
        }
        
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}



