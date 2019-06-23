//
//  MessageThreadViewController.swift
//  ApplozicSwift
//
//  Created by Mukesh on 08/06/19.
//

import UIKit
import DifferenceKit

protocol MessageThreadUpdate {
    func update(data: [String])
}

public class MessageThreadViewController: UITableViewController {

    // TODO: Add it in initialization
    var sections: [ArraySection<AnySection, AnyChatItem>] = []

    override public func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Replace this with empty cells
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = UIColor.red

        // FIXME:[Temporary] maybe Use UICollectionViewDelegateFlowLayout
//        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }

    func update(sections: [ArraySection<AnySection, AnyChatItem>]) {
        // First find out the diff then store
        let changeSet = StagedChangeset(source: self.sections, target: sections)
        tableView.reload(using: changeSet, with: UITableView.RowAnimation.automatic, setData: { data in
            self.sections = data
        })
        //        tableView?.reload(using: changeSet, interrupt: { $0.changeCount > 100 }, setData: { data in
//            self.sections = data
//        })
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {

        return sections.count
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > section else { return 0 }
        return sections[section].elements.count
    }


    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // TODO: Create an extension on ArraySections to access elements safely
        let section = sections[indexPath.section]
        let chatItem = section.model.viewModels[indexPath.row]

        let cell = section.model.cellForRow(chatItem, tableView: tableView, indexPath: indexPath)
        cell.backgroundColor = UIColor.green
        return cell
    }
}
