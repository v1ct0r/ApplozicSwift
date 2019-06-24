//
//  MessageSection.swift
//  ApplozicSwift
//
//  Created by Mukesh on 09/06/19.
//

import Foundation
import DifferenceKit

class MessageSection: Section {

    var model: AnyDifferentiable {
        return AnyDifferentiable(message)
    }

    var message: ALKMessageModel

    var viewModels = [AnyChatItem]()

    required init(_ message: ALKMessageModel) {
        self.message = message

        self.viewModels = makeViewModels(from: message)
    }

    func makeViewModels(from message: ALKMessageModel) -> [AnyChatItem] {
        var items = [AnyChatItem]()

        switch message.messageType {
        case .text:
            items.append(AnyChatItem(TextItem(text: message.message ?? "")))
//        case .imageMessage:

//            guard let imageMessage = message.imageMessage(),
//                let imageURL = URL(string: imageMessage.url) else {
//                break
//            }
            // Text
//            items.append(AnyChatItem(TextItem(text: message.message ?? "")))
            // Image
//            let item = ImageItem(url: imageURL)
//            items.append(AnyChatItem(item))
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

struct TextItem: ChatItem, Differentiable {
    var reuseIdentifier: String {
//        return ALKMyMessageCell.reuseIdentifier
        return SampleTableViewCell.reuseIdentifier
    }

    var text: String

    var differenceIdentifier: String {
        return text
    }

    func isContentEqual(to source: TextItem) -> Bool {
        return source.text == text
    }
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
