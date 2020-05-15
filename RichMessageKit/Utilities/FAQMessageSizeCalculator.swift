//
//  FAQMessageSizeCalculator.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 04/06/19.
//

import Foundation

class FAQMessageSizeCalculator {
    func rowHeight(model: FAQMessage, maxWidth: CGFloat) -> CGFloat {
        var faqHeight: CGFloat = 0
        var viewHeight: CGFloat = 0

        if model.message.isMyMessage {
            viewHeight += SentFAQMessageCell.Config.FaqView.bottomPadding + SentFAQMessageCell.Config.TimeLabel.bottomPadding
            if model.message.isMessageEmpty() {
                viewHeight += SentFAQMessageCell.Config.FaqView.topPadding +
                    SentFAQMessageCell.Config.MessageView.topPadding
            } else {
                let messageViewPadding = Padding(
                    left: SentFAQMessageCell.Config.MessageView.leftPadding,
                    right: SentFAQMessageCell.Config.MessageView.rightPadding,
                    top: SentFAQMessageCell.Config.MessageView.topPadding,
                    bottom: SentFAQMessageCell.Config.FaqView.topPadding
                )
                viewHeight += SentMessageViewSizeCalculator().rowHeight(messageModel: model.message, maxWidth: maxWidth, padding: messageViewPadding)
            }

            faqHeight = FAQMessageView.rowHeight(model: model, maxWidth: SentFAQMessageCell.faqWidth, style: FAQMessageTheme.sentMessage)
            viewHeight += model.message.time.rectWithConstrainedWidth(SentFAQMessageCell.Config.TimeLabel.maxWidth, font: MessageTheme.sentMessage.time.font).height.rounded(.up)

        } else {
            viewHeight += ReceivedFAQMessageCell.Config.DisplayName.height + ReceivedFAQMessageCell.Config.DisplayName.topPadding + ReceivedFAQMessageCell.Config.FAQView.bottomPadding +
                ReceivedFAQMessageCell.Config.TimeLabel.bottomPadding
            if model.message.isMessageEmpty() {
                viewHeight += ReceivedFAQMessageCell.Config.FAQView.topPadding +
                    ReceivedFAQMessageCell.Config.MessageView.topPadding
            } else {
                let messageViewPadding = Padding(
                    left: ReceivedFAQMessageCell.Config.MessageView.leftPadding,
                    right: ReceivedFAQMessageCell.Config.MessageView.rightPadding,
                    top: ReceivedFAQMessageCell.Config.MessageView.topPadding,
                    bottom: ReceivedFAQMessageCell.Config.FAQView.topPadding
                )
                viewHeight += ReceivedMessageViewSizeCalculator().rowHeight(messageModel: model.message, maxWidth: maxWidth, padding: messageViewPadding)
            }
            viewHeight += model.message.time.rectWithConstrainedWidth(ReceivedFAQMessageCell.Config.TimeLabel.maxWidth, font: MessageTheme.receivedMessage.time.font).height.rounded(.up)

            faqHeight = FAQMessageView.rowHeight(model: model, maxWidth: ReceivedFAQMessageCell.faqWidth, style: FAQMessageTheme.receivedMessage)
        }

        return viewHeight + faqHeight
    }
}
