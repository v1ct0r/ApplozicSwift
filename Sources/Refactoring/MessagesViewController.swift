//
//  MessagesViewController.swift
//  ApplozicSwift
//
//  Created by Mukesh on 10/06/19.
//

import Foundation
import DifferenceKit

private let reuseIdentifier = "Cell"

public class MessagesViewController: MessageThreadViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        let textMessage = ALKMessageModel()
        textMessage.message = "First message"
        textMessage.identifier = "12344"
        textMessage.messageType = .text

        let textSection = MessageSection(textMessage)
        let section = ArraySection(
            model: AnySection(textSection),
            elements: textSection.viewModels)
        update(sections: [section])
    }

    func convert(dict: Dictionary<String, String>) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? nil
        } catch {
            print(error)
            return nil
        }
    }
}
