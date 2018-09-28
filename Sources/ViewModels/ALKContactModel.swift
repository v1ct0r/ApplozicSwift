//
//  ALKContactModel.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 13/09/18.
//

import Foundation
import Applozic

final class ALKContactModel {
    
    var favouriteContacts: [ALContact]
    var registeredContacts: [ALContact]
    var unregisteredContacts: [ALContact]
    
    var contactList = [(key: Character , value: [ALContact])]()
    var bufferContactList = [(key: Character , value: [ALContact])]() {
        didSet {
            self.contactList = bufferContactList
        }
    }
    
    init() {
        favouriteContacts = [ALContact]()
        registeredContacts = [ALContact]()
        unregisteredContacts = [ALContact]()
        fetchContactList()
    }
    
    func fetchContacts(predicate: NSPredicate) -> [ALContact]{
        let dbHandler = ALDBHandler.sharedInstance()
        let fetchReq = NSFetchRequest<DB_CONTACT>(entityName: "DB_CONTACT")
        fetchReq.returnsDistinctResults = true
        fetchReq.predicate = predicate
        var contactList = [ALContact]()
        var sortedContactList = [ALContact]()
        do {
            let list = try dbHandler?.managedObjectContext.fetch(fetchReq)
            if let db = list {
                for dbContact in db {
                    let contact = ALContact()
                    contact.userId = dbContact.userId
                    contact.fullName = dbContact.fullName
                    contact.contactNumber = dbContact.contactNumber
                    contact.displayName = dbContact.displayName
                    contact.contactImageUrl = dbContact.contactImageUrl
                    contact.email = dbContact.email
                    contact.localImageResourceName = dbContact.localImageResourceName
                    contact.contactType = dbContact.contactType
                    contactList.append(contact)
                }
                sortedContactList = contactList.sorted(by: { (first, second) -> Bool in
                    if first.displayName != nil && second.displayName != nil{
                        return first.displayName < second.displayName
                    } else{
                        return first.userId < second.userId
                    }
                })
            }
        } catch( let error) {
            NSLog(error.localizedDescription)
        }
        return sortedContactList
    }
    
    func fetchContactList() {
        //GET Favourite contacts
        let favouritePredicate = NSPredicate(format: "userId!=%@ AND isFavourite == 1", ALUserDefaultsHandler.getUserId() ?? "")
//        let favouritePredicate = NSPredicate(format: "userId!=%@", ALUserDefaultsHandler.getUserId() ?? "")
        favouriteContacts = fetchContacts(predicate: favouritePredicate)
        if favouriteContacts.count > 0 {
            bufferContactList.append((key: "*", value: favouriteContacts))
        }
        
        //Get regitered Contacts
        let registeredPredicate = NSPredicate(format: "userId!=%@ AND contactType == 2 AND isFavourite == 0", ALUserDefaultsHandler.getUserId() ?? "")
//        let registeredPredicate = NSPredicate(format: "userId!=%@", ALUserDefaultsHandler.getUserId() ?? "")
        registeredContacts = fetchContacts(predicate: registeredPredicate)
        
        //Convert this array to sorted array of tuples
        let dict = Dictionary(grouping: registeredContacts, by: {
            $0.displayName != nil ? Character(String($0.displayName.first!).uppercased()) : Character(String($0.userId.first!).uppercased())
        })
        
        var tupleArray = dict.map { ($0.0, $0.1) }
        tupleArray.sort { (first, second) -> Bool in
            return first.0 < second.0
        }
        bufferContactList.append(contentsOf: tupleArray)
        
        //Get unregistered COntacts
        let unregisteredPredicate = NSPredicate(format: "userId!=%@ AND contactType == 1 AND isFavourite == 0", ALUserDefaultsHandler.getUserId() ?? "")
//        let unregisteredPredicate = NSPredicate(format: "userId!=%@", ALUserDefaultsHandler.getUserId() ?? "")
        unregisteredContacts = fetchContacts(predicate: unregisteredPredicate)
        if unregisteredContacts.count > 0 {
            bufferContactList.append((key: "_", value: unregisteredContacts))
        }
    }
    
    func numberOfSections() -> Int{
        return contactList.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int{
        return contactList[section].value.count
    }
    
    func contactForRow(indexPath: IndexPath, section: Int) -> ALContact{
        return contactList[section].value[indexPath.row]
    }
    
    func sectionHeaderTitle(section: Int) -> Character{
        return contactList[section].key
    }
    
    func sectionIndexTitle() -> [String]{
        var sections =  contactList.map({
            String($0.key)
        })
        sections.remove(object: "*")
        sections.remove(object: "_")
        return sections
    }
    
    func sectionForSectionIndexTitle(title: String) -> Int {
        return contactList.index {$0.key == title.first} ?? 0
    }
    
    func filter(keyword: String){
        guard !keyword.isEmpty else{
            self.contactList = self.bufferContactList
            return
        }
        
        var filteredContactList = [(key: Character, value: [ALContact])]()
        
        for (key, value) in bufferContactList {
            var contacts = [ALContact]()
            for contact in value{
                if contact.getDisplayName().lowercased().contains(keyword.lowercased()){
                    contacts.append(contact)
                }
            }
            if contacts.count > 0{
                filteredContactList.append((key: key, value: contacts) )
            }
        }
        
        self.contactList = filteredContactList
        
    }
}
