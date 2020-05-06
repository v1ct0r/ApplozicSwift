//
//  SentImageMessageViewSizeCalculator.swift
//  RichMessageKit
//
//  Created by Shivam Pokhriyal on 11/02/19.
//

import Foundation

class ImageMessageViewSizeCalculator {
    func rowHeight(model: ImageMessage, maxWidth: CGFloat, padding: Padding) -> CGFloat {
        var messageViewPadding: Padding!
        var viewHeight: CGFloat = 0
        if model.message.isMessageEmpty() {
            if model.message.isMyMessage {
                viewHeight = padding.bottom + padding.top
            } else {
                viewHeight = padding.bottom + padding.top
                    + ReceivedImageMessageCell.Config.DisplayName.height
            }
        } else {
            if model.message.isMyMessage {
                messageViewPadding = Padding(
                    left: padding.left,
                    right: padding.right,
                    top: padding.top,
                    bottom: SentImageMessageCell.Config.imageBubbleTopPadding
                )
                viewHeight = SentMessageViewSizeCalculator().rowHeight(messageModel: model.message, maxWidth: maxWidth, padding: messageViewPadding)
            } else {
                messageViewPadding = Padding(
                    left: padding.left,
                    right: padding.right,
                    top: padding.top,
                    bottom: ReceivedImageMessageCell.Config.imageBubbleTopPadding
                )
                viewHeight = ReceivedMessageViewSizeCalculator().rowHeight(messageModel: model.message, maxWidth: maxWidth, padding: messageViewPadding)
            }
        }

        if model.message.isMyMessage {
            viewHeight += model.message.time.rectWithConstrainedWidth(SentImageMessageCell.Config.TimeLabel.maxWidth, font: MessageTheme.sentMessage.time.font).height.rounded(.up)
        } else {
            viewHeight += model.message.time.rectWithConstrainedWidth(SentImageMessageCell.Config.TimeLabel.maxWidth, font: MessageTheme.receivedMessage.time.font).height.rounded(.up)
        }

        let imageBubbleHeight = ImageBubbleSizeCalculator().rowHeight(model: model, maxWidth: maxWidth)
        return viewHeight + imageBubbleHeight + padding.bottom // top will be already added in messageView
    }
}
