//
//  ALKMyQuickReplyCell.swift
//  ApplozicSwift
//
//  Created by apple on 15/04/20.
//

import Foundation
import Kingfisher

public class ALKMyQuickReplyButtonCell: ALKChatBaseCell<ALKMessageViewModel> {
    enum Padding {
        enum StateView {
            static let bottom: CGFloat = 1
            static let right: CGFloat = 2
            static let height: CGFloat = 9
            static let width: CGFloat = 17
        }

        enum TimeLabel {
            static let right: CGFloat = 2
            static let bottom: CGFloat = 2
        }
    }

    var timeLabel: UILabel = {
        let lb = UILabel()
        lb.isOpaque = true
        return lb
    }()

    var stateView: UIImageView = {
        let sv = UIImageView()
        sv.isUserInteractionEnabled = false
        sv.contentMode = .center
        return sv
    }()

    var quickReplyView = SuggestedReplyView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupStyle() {
        super.setupStyle()
        timeLabel.setStyle(ALKMessageStyle.time)
        setStatusStyle(statusView: stateView, ALKMessageStyle.messageStatus)
    }

    public func update(viewModel: ALKMessageViewModel, maxWidth: CGFloat) {
        timeLabel.text = viewModel.time
        setStatusStyle(statusView: stateView, ALKMessageStyle.messageStatus)
        var suggestedReplyData: SuggestedReplyMessage?
        if viewModel.messageType == .button {
            suggestedReplyData = viewModel.linkOrSubmitButton()
        } else if viewModel.messageType == .quickReply {
            suggestedReplyData = viewModel.suggestedReply()
        }
        guard let data = suggestedReplyData else {
            quickReplyView.isHidden = true
            return
        }
        let quickReplyViewWidth = maxWidth -
            (ChatCellPadding.SentMessage.QuickReply.left + ChatCellPadding.SentMessage.QuickReply.right)
        quickReplyView.update(model: data, maxWidth: quickReplyViewWidth)
    }

    public class func rowHeight(viewModel: ALKMessageViewModel, maxWidth: CGFloat) -> CGFloat {
        var height: CGFloat = 10 // Padding
        height += 20 // (6 + 4) + 10 for extra padding
        var suggestedReplyData: SuggestedReplyMessage?
        if viewModel.messageType == .button {
            suggestedReplyData = viewModel.linkOrSubmitButton()
        } else if viewModel.messageType == .quickReply {
            suggestedReplyData = viewModel.suggestedReply()
        }
        guard let data = suggestedReplyData else {
            return height
        }
        let quickReplyViewWidth = maxWidth -
            (ChatCellPadding.SentMessage.QuickReply.left + ChatCellPadding.SentMessage.QuickReply.right)
        return height
            + SuggestedReplyView.rowHeight(model: data, maxWidth: quickReplyViewWidth)
            + ChatCellPadding.SentMessage.QuickReply.top
            + ChatCellPadding.SentMessage.QuickReply.bottom
    }

    private func setupConstraints() {
        contentView.addViewsForAutolayout(views: [stateView, timeLabel, quickReplyView])
        bringSubviewToFront(stateView)

        NSLayoutConstraint.activate([
            quickReplyView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: ChatCellPadding.SentMessage.QuickReply.top
            ),
            quickReplyView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -ChatCellPadding.SentMessage.QuickReply.right
            ),
            quickReplyView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: ChatCellPadding.SentMessage.QuickReply.left),
            quickReplyView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -ChatCellPadding.SentMessage.QuickReply.bottom
            ),

            stateView.bottomAnchor.constraint(equalTo: quickReplyView.bottomAnchor, constant: -1 * Padding.StateView.bottom),
            stateView.trailingAnchor.constraint(equalTo: quickReplyView.leadingAnchor, constant: -1 * Padding.StateView.right),
            stateView.heightAnchor.constraint(equalToConstant: Padding.StateView.height),
            stateView.widthAnchor.constraint(equalToConstant: Padding.StateView.width),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: -1 * Padding.TimeLabel.right),
            timeLabel.bottomAnchor.constraint(equalTo: quickReplyView.bottomAnchor, constant: Padding.TimeLabel.bottom),

        ])
    }
}