//
//  CustomViewController.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 23/09/18.
//

import UIKit

open class CustomViewController: UITabBarController, UITabBarControllerDelegate {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let conversationVC = ALKConversationListViewController()
        conversationVC.title = "Conversation"
        conversationVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarItem.SystemItem.more, tag: 0)
        let convNav = UINavigationController(rootViewController: conversationVC)
        
        let contactsVC = ALKContactListViewController()
        contactsVC.title = "Contacts"
        contactsVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1)
        let contNav = UINavigationController(rootViewController: contactsVC)
        
        
        viewControllers = [convNav, contNav]
        
        //        let controllers = [conversationVC, contactsVC]
        //        self.tabBarController?.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        //        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    

}
