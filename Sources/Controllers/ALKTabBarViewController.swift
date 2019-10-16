//
//  ALKTabBarViewController.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 19/09/19.
//

import UIKit

@objc public class ALKTabBarViewController: UITabBarController {

    @objc public let conversationVC = ALKConversationListViewController()
    @objc public let contactsVC = ALKContactListViewController()

    override public func viewDidLoad() {
        super.viewDidLoad()
        conversationVC.title = "Conversation"
        let image = UIImage(named: "chat_default", in: Bundle.applozic, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        conversationVC.tabBarItem = UITabBarItem(title: "My Chats", image: image, tag: 0)

        contactsVC.title = "Contacts"
        contactsVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1)

        let controllers = [conversationVC, contactsVC]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        tabBar.backgroundColor = UIColor.white
    }
}
