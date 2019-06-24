//
//  SampleTableViewCell.swift
//  ApplozicSwift
//
//  Created by Mukesh on 20/06/19.
//

import UIKit

class SampleTableViewCell: UITableViewCell, ChatCell {


    var viewModel: AnyChatItem? {
        didSet {
            setup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup() {
        guard let viewModel = viewModel?.base as? TextItem else { return }
        textLabel?.text = viewModel.text
    }

}
