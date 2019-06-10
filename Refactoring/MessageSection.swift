//
//  MessageSection.swift
//  ApplozicSwift
//
//  Created by Mukesh on 09/06/19.
//

import Foundation
import DifferenceKit

class MessageSection: Section {

    var message: ALKMessageModel
    var viewModels = [ChatItem]()

    required init(_ message: ALKMessageModel) {
        self.message = message

        self.viewModels = makeViewModels(from: message)
    }

    func makeViewModels(from message: ALKMessageModel) -> [ChatItem] {
        var items = [ChatItem]()

        switch message.messageType {
        case .text:
            items.append(TextItem(text: message.message ?? ""))
        case .imageMessage:

            guard let imageMessage = message.imageMessage(),
                let imageURL = URL(string: imageMessage.url) else {
                break
            }
            // Text
            items.append(TextItem(text: message.message ?? ""))
            // Image
            let item = ImageItem(url: imageURL)
            items.append(item)
        default:
            print("type not supported")
        }
        return items
    }
}

//TODO: Use this as the first item(for user name, icon) and create cell for this.
struct UserItem: ChatItem {
    var reuseIdentifier: String {
        return "cell"
    }
}

struct TextItem: ChatItem {
    var reuseIdentifier: String {
        return ALKMyMessageCell.reuseIdentifier
    }

    var text: String
}

struct ImageItem: ChatItem {
    var reuseIdentifier: String {
        return SentImageMessageCell.reuseIdentifier
    }

    var url: URL
}

extension ALKMessageModel: Differentiable {

    public var differenceIdentifier: Int {
        return Int(identifier) ?? 0
    }

    public func isContentEqual(to source: ALKMessageModel) -> Bool {
        return self.identifier == source.identifier
    }
}
