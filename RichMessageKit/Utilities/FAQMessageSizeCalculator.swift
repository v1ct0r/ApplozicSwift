//
//  FAQMessageSizeCalculator.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 04/06/19.
//

import Foundation

class FAQMessageSizeCalculator {
    func rowHeight(model: FAQMessage, maxWidth: CGFloat, padding: Padding) -> CGFloat {
        var faqHeight: CGFloat = 0

        var viewHeight: CGFloat = 0
        if model.message.isMessageEmpty() {
            if model.message.isMyMessage {
                viewHeight += padding.top + SentFAQMessageCell.Config.faqTopPadding
            } else {
                viewHeight += padding.top
                    + ReceivedFAQMessageCell.Config.DisplayName.height + ReceivedFAQMessageCell.Config.faqTopPadding
            }
        } else {
            if model.message.isMyMessage {
                let messageViewPadding = Padding(
                    left: padding.left,
                    right: padding.right,
                    top: padding.top,
                    bottom: SentFAQMessageCell.Config.faqTopPadding
                )
                viewHeight = SentMessageViewSizeCalculator().rowHeight(messageModel: model.message, maxWidth: maxWidth, padding: messageViewPadding)

            } else {
                let messageViewPadding = Padding(
                    left: padding.left,
                    right: padding.right,
                    top: padding.top,
                    bottom: ReceivedFAQMessageCell.Config.faqTopPadding
                )
                viewHeight = ReceivedMessageViewSizeCalculator().rowHeight(messageModel: model.message, maxWidth: maxWidth, padding: messageViewPadding)
            }
        }

        if model.message.isMyMessage {
            faqHeight = FAQMessageView.rowHeight(model: model, maxWidth: SentFAQMessageCell.faqWidth, style: FAQMessageTheme.sentMessage)
            viewHeight += model.message.time.rectWithConstrainedWidth(SentFAQMessageCell.Config.TimeLabel.maxWidth, font: MessageTheme.sentMessage.time.font).height.rounded(.up) + padding.bottom

        } else {
            viewHeight += model.message.time.rectWithConstrainedWidth(ReceivedFAQMessageCell.Config.TimeLabel.maxWidth, font: MessageTheme.sentMessage.time.font).height.rounded(.up) + padding.bottom

            faqHeight = FAQMessageView.rowHeight(model: model, maxWidth: ReceivedFAQMessageCell.faqWidth, style: FAQMessageTheme.receivedMessage)
        }

        return viewHeight + faqHeight + padding.bottom // top will be already added in messageView
    }
}
