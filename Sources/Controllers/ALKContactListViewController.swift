//
//  ALKContactListViewController.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 13/09/18.
//

import UIKit

open class ALKContactListViewController: ALKBaseViewController {
    
    fileprivate var viewModel: ALKContactModel
    
    fileprivate let tableView : UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.estimatedRowHeight   = 53
        tv.rowHeight            = 53
        tv.separatorStyle       = .none
        tv.backgroundColor      = UIColor.white
        tv.keyboardDismissMode  = .onDrag
        return tv
    }()
    
    fileprivate lazy var searchBar: UISearchBar = {
        return UISearchBar.createAXSearchBar(placeholder: NSLocalizedString("SearchPlaceholder", value: "Search", comment: ""))
    }()
    
    required public init() {
        self.viewModel = ALKContactModel()
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    private func setupView() {
        title = NSLocalizedString("ContactList", value: "Contacts", comment: "")
        
        view.addViewsForAutolayout(views: [searchBar, tableView])
        setupSearchBarConstraint()
        setupTableViewConstraint()
        searchBar.delegate = self
        // Setup table view datasource/delegate
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        registerCell()
    }
    
    //SET UP SEARCH BAR CONSTRAINT
    private func setupSearchBarConstraint() {
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //SET UP TABLE VIEW CONSTRAINT
    private func setupTableViewConstraint() {
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func registerCell() {
        tableView.register(ALKContactCell.self)
    }

}

//MARK: - UITableViewDelegate
extension ALKContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactViewModel = viewModel.contactForRow(indexPath: indexPath, section: indexPath.section)
        let cell: ALKContactCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.update(contact: contactViewModel)
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(viewModel.sectionHeaderTitle(section: section))
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionIndexTitle()
    }
}

//MARK: - UISearchBarDelegate
extension ALKContactListViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(keyword: searchText)
        tableView.reloadData()
    }
}
