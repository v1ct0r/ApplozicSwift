//
//  ReceivedMessageViewSizeCalculator.swift
//  RichMessageKit
//
//  Created by Shivam Pokhriyal on 26/01/19.
//

import Foundation

class ReceivedMessageViewSizeCalculator {
    func rowHeight(messageModel: Message, maxWidth: CGFloat, padding: Padding) -> CGFloat {
        let message = messageModel.text ?? ""
        let config = ReceivedMessageView.Config.self

        let totalWidthPadding = padding.left + padding.right + config.MessageView.leftPadding

        let messageWidth = maxWidth - totalWidthPadding
        let messageHeight = MessageViewSizeCalculator().rowHeight(
            text: message,
            font: MessageTheme.receivedMessage.message.font,
            maxWidth: messageWidth,
            padding: MessageTheme.receivedMessage.bubble.padding
        )

        let totalHeightPadding = padding.top + padding.bottom + config.MessageView.topPadding + config.MessageView.bottomPadding
        let calculatedHeight = messageHeight + totalHeightPadding
        return calculatedHeight
    }
}
