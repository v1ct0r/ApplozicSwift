//
//  SampleTableViewCell.swift
//  ApplozicSwift
//
//  Created by Mukesh on 20/06/19.
//

import UIKit

class SampleTableViewCell: UITableViewCell, ChatCell {

    var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 200, y: 20, width: 80, height: 30))
        return button
    }()

    var viewModel: AnyChatItem? {
        didSet {
            setup()
        }
    }

    var onDelete:(() -> ()) = { }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup() {
        guard let viewModel = viewModel?.base as? TextItem else { return }
        textLabel?.text = viewModel.text
        self.onDelete = viewModel.onDeleteCallback

        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }

    @objc func deleteAction() {
        self.onDelete()
    }

}
