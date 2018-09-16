//
//  ViewController.swift
//  ApplozicSwiftDemo
//
//  Created by Mukesh Thawani on 11/08/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import UIKit
import Applozic
import ApplozicSwift

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        //        registerAndLaunch()
    }

    override func viewDidLoad() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func logoutAction(_ sender: UIButton) {
        let registerUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
        registerUserClientService.logout { (response, error) in

        }
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func launchChatList(_ sender: Any) {
        
//        let conversationVC = ALKConversationListViewController()
//        let nav = ALKBaseNavigationViewController(rootViewController: conversationVC)
//        self.present(nav, animated: false, completion: nil)

        let tabBarController = UITabBarController()
        let conversationVC = ALKConversationListViewController()
        conversationVC.title = "Conversation"
        conversationVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.contacts, tag: 0)

        let contactsVC = ALKContactListViewController()
        contactsVC.title = "Contacts"
        contactsVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1)
        
        let controllers = [conversationVC, contactsVC]
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        tabBarController.tabBar.backgroundColor = ALKConfiguration.init().customPrimary
        self.present(tabBarController, animated: false, completion: nil)
    }
}
