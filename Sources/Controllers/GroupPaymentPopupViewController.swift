//
//  GroupPaymentPopupViewController.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 18/09/18.
//

import UIKit

enum headerCheckBoxState: String {
    case none
    case selectAll
    case deselectAll
}

protocol GroupPaymentActionProtocol: class {
    func accept(paymentModel: ALKPaymentModel)
}

class GroupPaymentPopupViewController: UIViewController {
    
    public var groupId: NSNumber!
    
    fileprivate var viewModel: GroupPaymentPopupViewModel
    
    fileprivate var indexPathOfSelectedRows = [IndexPath]()
    
    fileprivate var isSelectAll = headerCheckBoxState.none
    
    fileprivate var delegate: GroupPaymentActionProtocol!
    
    fileprivate var paymentModel: ALKPaymentModel!
    
    fileprivate var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.estimatedRowHeight       = 53
        tv.rowHeight                = 53
        tv.separatorStyle           = .none
        tv.backgroundColor          = UIColor.white
        tv.keyboardDismissMode      = .onDrag
        tv.allowsMultipleSelection  = true
        return tv
    }()
    
    fileprivate var popupTitle: UILabel = {
        let label           = UILabel()
        label.textColor     = ALKConfiguration.init().customPrimaryDark
        label.font          = UIFont.boldSystemFont(ofSize: 20)
        label.text          = NSLocalizedString("GroupPaymentPopupTitle", value: SystemMessage.PaymentPopup.title, comment: "")
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate var popupDescription: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.textColor     = UIColor.lightGray
        label.text          = NSLocalizedString("GroupPaymentPopupMessage", value: SystemMessage.PaymentPopup.message, comment: "")
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate var acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = NSLocalizedString("GroupPaymentPopupAcceptButton", value: SystemMessage.PaymentPopup.acceptButton, comment: "")
        button.setTitle(title, for: .normal)
        button.setTitleColor(ALKConfiguration.init().customPrimaryDark, for: .normal)
        return button
    }()
    
    fileprivate var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = NSLocalizedString("GroupPaymentPopupRejectButton", value: SystemMessage.PaymentPopup.rejectButton, comment: "")
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
    
    fileprivate lazy var actionButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.cancelButton, self.acceptButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    fileprivate var modalView: UIView = {
        let view                = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()
    
    required public init(groupId: NSNumber, delegate: GroupPaymentActionProtocol) {
        self.viewModel = GroupPaymentPopupViewModel()
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.groupId = groupId
        viewModel.fetchContactsForGroup(groupId: self.groupId)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.view.addViewsForAutolayout(views: [modalView])
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0) + 20
        
        modalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        modalView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topBarHeight).isActive = true
        modalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        modalView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -1).isActive = true
        
        modalView.addViewsForAutolayout(views: [popupTitle, popupDescription, tableView, actionButtons])
        //SET UP POP_UP_TITLE
        popupTitle.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 10).isActive = true
        popupTitle.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 20).isActive = true
        popupTitle.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -10).isActive = true
        
        //SET UP POP_UP_DESCRIPTION
        popupDescription.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 10).isActive = true
        popupDescription.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 10).isActive = true
        popupDescription.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -10).isActive = true
        
        //SET UP TABLE_VIEW
        tableView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 10).isActive = true
        tableView.topAnchor.constraint(equalTo: popupDescription.bottomAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: actionButtons.topAnchor, constant: -10).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //SET UP ACTION BUTTONS
        actionButtons.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 10).isActive = true
        actionButtons.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        actionButtons.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -10).isActive = true
        actionButtons.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -10).isActive = true
        
        //SET UP TABLEVIEW DATASOURCE AND DELEGATE AND CELL
        tableView.register(GroupPaymentPopupCell.self)
        tableView.register(GroupPaymentPopupHeader.self, forHeaderFooterViewReuseIdentifier: "tableHeader")
        tableView.delegate = self
        tableView.dataSource = self
        
        //SET UP ACTIONS TO BUTTONS
        cancelButton.addTarget(self, action: #selector(handleButtonClick(_ :)), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(handleButtonClick(_ :)), for: .touchUpInside)
    }
    
    func handleButtonClick(_ button: UIButton) {
        // Ask the view controller that presented us to dismiss us...
        switch(button){
        case cancelButton:
            print("Don't want to send payment right now. No worries. You can always send it later at your will.")
            self.dismiss(animated: true, completion: nil)
        case acceptButton:
            var userIds = [String]()
            for indexPath in indexPathOfSelectedRows {
                let contact = viewModel.contactForRow(indexPath: indexPath)
                userIds.append(contact.userId)
            }
            paymentModel.usersRequested = NSMutableArray(array: userIds)
            delegate.accept(paymentModel: paymentModel)
        default:
            print("This should never occur.. No button selected in group Popup")
        }
        indexPathOfSelectedRows.removeAll()
    }
    
    func setPaymentModel(_ paymentModel: ALKPaymentModel){
        self.paymentModel = paymentModel
    }
    
}

extension GroupPaymentPopupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactViewModel = viewModel.contactForRow(indexPath: indexPath)
        let cell: GroupPaymentPopupCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.update(contact: contactViewModel)
        
        // To make sure selection doesn't go away when tableview reloads
        if indexPathOfSelectedRows.contains(indexPath) {
            cell.selectCheckBox()
        }else {
            cell.deselectCheckBox()
        }
        
        //See if selectAll checkbox is clicked
        if isSelectAll == headerCheckBoxState.selectAll {
            if !indexPathOfSelectedRows.contains(indexPath){
                indexPathOfSelectedRows.append(indexPath)
            }
            cell.selectCheckBox()
        } else if isSelectAll == headerCheckBoxState.deselectAll {
            cell.deselectCheckBox()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: GroupPaymentPopupHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "tableHeader") as! GroupPaymentPopupHeader
        header.setDelegate(delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: GroupPaymentPopupCell = tableView.cellForRow(at: indexPath) as! GroupPaymentPopupCell
        
        //If selectall is enabled then remove this from indexPath
        if isSelectAll == headerCheckBoxState.selectAll {
            isSelectAll = headerCheckBoxState.none
            indexPathOfSelectedRows.remove(object: indexPath)
            selectedCell.deselectCheckBox()
            //deselect header checkbox too
            let header = tableView.headerView(forSection: 0) as! GroupPaymentPopupHeader
            header.deselectCheckBox()
            return
        }
        
        populateIndexPathOfSelectedRows(indexPath: indexPath, selectedCell: selectedCell)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell: GroupPaymentPopupCell = tableView.cellForRow(at: indexPath) as! GroupPaymentPopupCell
        populateIndexPathOfSelectedRows(indexPath: indexPath, selectedCell: selectedCell)
    }
    
    func populateIndexPathOfSelectedRows(indexPath: IndexPath, selectedCell: GroupPaymentPopupCell) {
        if indexPathOfSelectedRows.contains(indexPath) {
            indexPathOfSelectedRows.remove(object: indexPath)
            selectedCell.deselectCheckBox()
        }else {
            indexPathOfSelectedRows.append(indexPath)
            selectedCell.selectCheckBox()
        }
    }
}

extension GroupPaymentPopupViewController: GroupPaymentPopupHeaderProtocol {
    func selectAll() {
        isSelectAll = headerCheckBoxState.selectAll
        tableView.reloadData()
    }
    
    func deselectAll() {
        isSelectAll = headerCheckBoxState.deselectAll
        tableView.reloadData()
        indexPathOfSelectedRows.removeAll()
        isSelectAll = headerCheckBoxState.none
    }
}
