//
//  ChatSection.swift
//  ApplozicSwift
//
//  Created by Mukesh on 01/07/19.
//

import Foundation
import DifferenceKit
import Applozic

struct ChatSection: Section {

    var model: AnyDifferentiable {
        return AnyDifferentiable(message)
    }

    let message: ALMessage

    var viewModels = [AnyChatItem]()
    weak var controllerContext: UIViewController?

    var chatController: TChatCellDelegate? {
        return controllerContext as? TChatCellDelegate
    }

    private let contactService: ALContactService
    private let channelService: ALChannelService

    init(message: ALMessage,
         contactService: ALContactService,
         channelService: ALChannelService,
         controllerContext: UIViewController?) {

        self.message = message
        self.contactService = contactService
        self.channelService = channelService
        self.controllerContext = controllerContext

        self.viewModels = makeViewModels()
    }

    private func makeViewModels() -> [AnyChatItem] {
        var items: [AnyChatItem] = []

        if let channelId = message.groupId {
            guard let channel = channelService.getChannelByKey(channelId) else {
                return items
            }
            let chatItem = TChatViewModel(
                message: message,
                channel: channel,
                isMember: !channelService.isChannelLeft(channelId))
            items.append(AnyChatItem(chatItem))
        } else if let contactId = message.contactId {
            guard let contact = contactService.loadContact(
                byKey: "userId",
                value: contactId) else {
                    return items
            }
            let chatItem = TChatViewModel(message: message, contact: contact)
            items.append(AnyChatItem(chatItem))
        }
        return items
    }

    func cellForRow(_ viewModel: AnyChatItem, tableView: UITableView, indexPath: IndexPath) -> ChatCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: viewModel.reuseIdentifier,
                for: indexPath) as? TChatCell else {
                    // Pass empty cell
                    return SampleTableViewCell()
        }
        cell.viewModel = viewModel
        cell.chatCellDelegate = chatController
        return cell
    }
}

extension ALMessage: Differentiable {

    public var differenceIdentifier: Int {
        return Int(identifier) ?? 0
    }

    public func isContentEqual(to source: ALMessage) -> Bool {
        return self.identifier == source.identifier
    }
}
