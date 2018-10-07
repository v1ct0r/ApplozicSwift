//
//  ALPaymentUsersController.swift
//  ApplozicSwift
//
//  Created by Sunil on 23/01/18.
//

import Foundation
import UIKit
import Applozic




class ALPaymentUsersController: ALKBaseViewController {
    
    // MARK: - UI Stuff
    @IBOutlet private var btnInvite: UIButton!
    @IBOutlet fileprivate var tblParticipants: UITableView!
    
    fileprivate var tapToDismiss:UITapGestureRecognizer?
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Data Stuff
    
    
    fileprivate var datasource = ALKFriendDatasource()
    open var groupId: NSNumber?
    open var groupMembers: [String]?
    open var isView: Bool = false
    
    // MARK: - Initially Setup
    var friendsInGroup: [ALKFriendViewModel]?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if let textField = searchController.searchBar.textField,
            UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            textField.textAlignment = .right
        }
        
        changeNewlyInvitedContact()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFriendList()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupInviteButton()
        setupSearchBar()
        
        self.navigationItem.title = NSLocalizedString("PaymentUsersTitle", value: SystemMessage.PaymentUsers.PaymentUsersTitle, comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        
        
        definesPresentationContext = true
        btnInvite.setTitle(NSLocalizedString("AddUsers", value: SystemMessage.PaymentUsers.AddUsers, comment: ""), for: .normal)
        if(isView){
            tblParticipants.allowsSelection = true;
        }else{
            tblParticipants.allowsSelection = false;
        }
        
        tblParticipants.tableHeaderView = searchController.searchBar
    }
    
    private func setupInviteButton() {
        if(isView){
            btnInvite.isHidden = false;
        }else{
            btnInvite.isHidden = true;
        }
        btnInvite.layer.cornerRadius = 15
        btnInvite.clipsToBounds = true
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation   = false
        searchController.searchBar.delegate                 = self
        searchController.searchBar.applySearchBarStyle()
    }
    
    // MARK: - Overriden methods
    override func backTapped() {
        let completion = { [weak self] in
            guard let weakSelf = self else { return }
            _ = weakSelf.navigationController?.popViewController(animated: true)
        }

    }
    
    // MARK: - API Logic
    func fetchFriendList() {
        
        getAllFriends {
            // Get existing friends in this group
            self.tblParticipants.reloadData()
        }
    }
    
    //MARK: - UI controller
    @IBAction func dismisssPress(_ sender: Any) {
        let dd =    navigationController?.popViewController(animated: true)
        
        if dd == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func getAllFriends(completion: @escaping () -> ()) {
        let dbHandler = ALDBHandler.sharedInstance()
        
        if(groupId != nil){
            
            let channelService = ALChannelService();
            
            let nsArray =  channelService.getListOfAllUsers(inChannel:groupId) as! [String]
            
            
            let contactDb = ALContactDBService();
            var models = [ALKFriendViewModel]()
            if(nsArray != nil){
                
                for i in 0..<nsArray.count{
                    
                    let userId  = nsArray[i]
                    
                    if(ALUserDefaultsHandler.getUserId() != userId ){
                        let  alContact =  contactDb.loadContact(byKey: "userId", value: userId)
                        models.append(ALKFriendViewModel.init(identity: alContact!))
                        
                    }
                }
            }
            
            
            self.datasource.update(datasource: models, state: .full)
            completion()
            
        }else if(groupMembers != nil){
            
            
            let contactDb = ALContactDBService();
            var models = [ALKFriendViewModel]()
            
            let nsArray =  groupMembers as! [String]
            
            
            for i in 0..<nsArray.count{
                
                let userId  = nsArray[i]
                
                let  alContact =  contactDb.loadContact(byKey: "userId", value: userId)
                models.append(ALKFriendViewModel.init(identity: alContact!))
                
            }
            
            self.datasource.update(datasource: models, state: .full)
            completion()
    
        }
        
    }
    
    
    //MARK: - Handle keyboard
    fileprivate func hideSearchKeyboard() {
        tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissSearchKeyboard))
        view.addGestureRecognizer(tapToDismiss!)
    }
    
    func dismissSearchKeyboard() {
        if let text = searchController.searchBar.text, text.isEmpty == true {
            searchController.isActive = false
        }
        searchController.searchBar.endEditing(true)
        searchController.dismissKeyboard()
        view.endEditing(true)
    }
    
    // MARK: - IBAction
    @IBAction func invitePress(_ sender: Any) {
        btnInvite.isEnabled = false
        var selectedFriendList = [ALKFriendViewModel]()
        //get all friends selected into a list
        for fv in datasource.getDatasource(state: .full) {
            if fv.getIsSelected() == true {
                
                selectedFriendList.append(fv)
            }
        }
        
        let addedFriendList = getAddedFriend(allFriendsInGroup: selectedFriendList)

    }
    
    // MARK: - Other
    private func getNewGroupMemberCount() -> Int {
        return self.datasource.getDatasource(state: .full).filter { (friendViewModel) -> Bool in
            friendViewModel.getIsSelected() == true && !isInPreviousFriendGroup(fri: friendViewModel)
            }.count
    }
    
    fileprivate func changeNewlyInvitedContact() {
        let count = getNewGroupMemberCount()
        
        let (title, background, isEnabled) = getButtonAppearance(invitedFriendCount: count)
        btnInvite.isEnabled = isEnabled
        btnInvite.backgroundColor = background
        btnInvite.setTitle(title, for: .normal)
    }
    
    private func getAddedFriend(allFriendsInGroup: [ALKFriendViewModel]) -> [ALKFriendViewModel] {
        var addedFriendList = [ALKFriendViewModel]()
        for friend in allFriendsInGroup {
            if !isInPreviousFriendGroup(fri: friend) {
                addedFriendList.append(friend)
            }
        }
        return addedFriendList
    }
    
    fileprivate func isInPreviousFriendGroup(fri: ALKFriendViewModel) -> Bool {
        guard let friendUUID = fri.friendUUID, let friendsInGroup = self.friendsInGroup else { return false }
        return friendsInGroup
            .filter { $0.friendUUID == friendUUID }
            .count > 0
    }
    
}

extension ALPaymentUsersController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let state = ALKDatasourceState(isInUsed: searchController.isActiveAndContainText())
        return datasource.count(state: state)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ALKFriendContactCell", for: indexPath) as? ALKFriendContactCell {
            
            let state = ALKDatasourceState(isInUsed: searchController.isActiveAndContainText())
            
            guard let fri = datasource.getItem(atIndex: indexPath.row, state: state) else {
                return UITableViewCell()
            }
            
            let isExistingFriendInGroup = isInPreviousFriendGroup(fri: fri)
            
            cell.update(viewModel: fri, isExistingFriend: isExistingFriendInGroup)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isView){
            let state = ALKDatasourceState(isInUsed: searchController.isActiveAndContainText())
            
            guard let fri = datasource.getItem(atIndex: indexPath.row, state: state) else { return }
            
            handleTappingContact(friendViewModel: fri)
            
            datasource.updateItem(item: fri, atIndex: indexPath.row, state: state)
            
            if !isInPreviousFriendGroup(fri: fri) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    tableView.deselectRow(at: indexPath, animated: true)
                    tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                })
            }
        }
        
    }
    
    private func keepTrackTappingNewlySelectedContact(fri: ALKFriendViewModel) {
        if let friendUUID = fri.friendUUID {
            if !fri.isSelected {
                //  newFriendsInGroupStore.storeParticipantID(idString: friendUUID)
            } else {
                //  newFriendsInGroupStore.removeParticipantID(idString: friendUUID)
            }
        }
    }
    
    private func handleTappingContact(friendViewModel: ALKFriendViewModel) {
        if isInPreviousFriendGroup(fri: friendViewModel) { return }
        
        keepTrackTappingNewlySelectedContact(fri: friendViewModel)
        
        friendViewModel.setIsSelected(select: !friendViewModel.isSelected)
        
        changeNewlyInvitedContact()
    }
    

}

extension ALPaymentUsersController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideSearchKeyboard()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let tab = tapToDismiss {
            view.removeGestureRecognizer(tab)
            tapToDismiss = nil
        }
    }
    
    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        let filteredList = datasource.getDatasource(state: .full).filter { friendViewModel in
            friendViewModel.getFriendDisplayName().lowercased().contains(searchText.lowercased())
        }
        datasource.update(datasource: filteredList, state: .filtered)
        self.tblParticipants.reloadData()
    }
}

extension ALPaymentUsersController: ALKInviteButtonProtocol {
    
    func getButtonAppearance(invitedFriendCount count: Int) -> (String, backgroundColor: UIColor, isEnabled: Bool) {
        let isEnabled = (count > 0) ? true: false
        let background = (isEnabled ? UIColor.mainRed() : UIColor.disabledButton())
        let newMember = count > 0 ? " (\(count))" : ""
        let inviteMessage = NSLocalizedString("InviteMessage", value: SystemMessage.LabelName.InviteMessage, comment: "")
        let title = "\(inviteMessage) \(newMember)"
        return (title, background, isEnabled)
    }
}


