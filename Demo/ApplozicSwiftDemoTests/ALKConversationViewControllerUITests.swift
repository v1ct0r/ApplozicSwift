//
//  ALKConversationViewControllerUITests.swift
//  ApplozicSwiftDemoTests
//
//  Created by Mukesh Thawani on 17/06/18.
//  Copyright © 2018 Applozic. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots
import Applozic
@testable import ApplozicSwift

class ALKConversationViewControllerUITests: QuickSpec {

    override func spec() {
        
        describe("Conversation list") {


            var conversationVC: ALKConversationListViewController!
            var navigationController: UINavigationController!

            //TODO: Add login call here

            beforeEach {
                conversationVC = ALKConversationListViewController(configuration: ALKConfiguration())
                navigationController = ALKBaseNavigationViewController(rootViewController: conversationVC)
            }

            it("Show list") {
                expect(navigationController) == snapshot()
            }

            it("Open chat thread") {
                conversationVC.beginAppearanceTransition(true, animated: false)
                conversationVC.endAppearanceTransition()
                conversationVC.tableView.delegate?.tableView?(conversationVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
                expect(conversationVC.navigationController).toEventually(haveValidSnapshot())
            }
        }
    }

    func getApplicationKey() -> NSString {

        let appKey = ALUserDefaultsHandler.getApplicationKey() as NSString?
        let applicationKey = appKey
        return applicationKey!;
    }

    func registerUser(_ alUser: ALUser, completion : @escaping (_ response: ALRegistrationResponse?, _ error: NSError?) -> Void) {

        let alChatLauncher: ALChatLauncher = ALChatLauncher(applicationId: getApplicationKey() as String)

        let registerUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()

        registerUserClientService.initWithCompletion(alUser, withCompletion: { (response, error) in

            if (error != nil)
            {
                print("Error while registering to applozic");
                let errorPass = NSError(domain:"Error while registering to applozic", code:0, userInfo:nil)
                completion(response , errorPass as NSError?)
            }
            else if(!(response?.isRegisteredSuccessfully())!)
            {
                ALUtilityClass.showAlertMessage("Invalid Password", andTitle: "Oops!!!")
                let errorPass = NSError(domain:"Invalid Password", code:0, userInfo:nil)
                completion(response , errorPass as NSError?)
            }
            else
            {
                print("registered")
//                if(ALChatManager.isNilOrEmpty(ALUserDefaultsHandler.getApnDeviceToken() as NSString?))
//                {
//                    alChatLauncher.registerForNotification()
//                }
                completion(response , error as NSError?)
            }
        })
    }

}
