//
//  MessagesViewController.swift
//  ApplozicSwift
//
//  Created by Mukesh on 10/06/19.
//

import Foundation

class MessagesViewController: MessageThreadViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let textMessage = ALKMessageModel()
        textMessage.message = "First message"
        textMessage.identifier = "12344"
        textMessage.messageType = .text

        let imageMessage = ALKMessageModel()
        let payload = convert(
            dict: ["caption": "Image caption", "url": "Image URL"]) ?? ""

        let imageMetadata = [
            "contentType": "300",
            "templateId": "9",
            "payload": "\(payload)"
        ]
        imageMessage.metadata = imageMetadata
        
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
