//
//  GroupPaymentPopupViewModel.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 18/09/18.
//

import Foundation
import Applozic

final class GroupPaymentPopupViewModel {
    
    var contactList: [ALContact]
    
    init() {
        contactList = [ALContact]()
    }
    
    func fetchContactsForGroup(groupId: NSNumber){
        let channelService = ALChannelService()
        let contactService = ALContactService()
        for userId in channelService.getListOfAllUsers(inChannel: groupId) {
            let contact = contactService.loadContact(byKey: "userId", value: userId as! String) as ALContact
            contactList.append(contact)
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection() -> Int{
        return contactList.count
    }
    
    func contactForRow(indexPath: IndexPath) -> ALContact {
        return contactList[indexPath.row]
    }
    
}
