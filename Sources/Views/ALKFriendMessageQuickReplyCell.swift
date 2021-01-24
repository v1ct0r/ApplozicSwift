//
//  ALKFriendQuickReplyCell.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 07/01/19.
//
// Migrated to ALKMessageCell

import Applozic
import Kingfisher
public class ALKFriendMessageQuickReplyCell: ALKMessageCell {
    enum Padding {
        enum NameLabel {
            static let top: CGFloat = 6
            static let leading: CGFloat = 57
            static let trailing: CGFloat = 57
            static let height: CGFloat = 16
        }

        struct AvatarImage {
            static let top: CGFloat = 18
            static let leading: CGFloat = 9
            static let width: CGFloat = 37
            static let height: CGFloat = 37
        }
        
        struct BubbleView {
            static let leading: CGFloat = 5.0
            static let trailing: CGFloat = 95.0
            static let bottom: CGFloat = 5.0
        }

        struct ReplyView {
            static let leading: CGFloat = 5.0
            static let trailing: CGFloat = 5.0
            static let top: CGFloat = 5.0
            static let height: CGFloat = 80.0
        }

        struct ReplyNameLabel {
            static let trailing: CGFloat = 10.0
            static let height: CGFloat = 30.0
        }

        struct ReplyMessageLabel {
            static let trailing: CGFloat = 10.0
            static let top: CGFloat = 5.0
            static let height: CGFloat = 30.0
        }

        struct PreviewImageView {
            static let height: CGFloat = 50.0
            static let width: CGFloat = 70.0
            static let trailing: CGFloat = 5.0
            static let top: CGFloat = 10.0
        }

        struct MessageView {
            static let top: CGFloat = 5
            static let bottom: CGFloat = 10
        }
        
        enum TimeLabel {
            static var leading: CGFloat = 2.0
            static var bottom: CGFloat = 2.0
            static let maxWidth: CGFloat = 200
        }
    }

    static let bubbleViewLeftPadding: CGFloat = {
        /// For edge add extra 5
        guard ALKMessageStyle.receivedBubble.style == .edge else {
            return ALKMessageStyle.receivedBubble.widthPadding
        }
        return ALKMessageStyle.receivedBubble.widthPadding + 5
    }()

    fileprivate var avatarImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        let layer = imv.layer
        layer.cornerRadius = 18.5
        layer.masksToBounds = true
        imv.isUserInteractionEnabled = true
        return imv
    }()

    fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isOpaque = true
        return label
    }()

    fileprivate lazy var timeLabelWidth = timeLabel.widthAnchor.constraint(equalToConstant: 0)
    fileprivate lazy var timeLabelHeight = timeLabel.heightAnchor.constraint(equalToConstant: 0)

    var quickReplyView = SuggestedReplyView()
    var quickReplySelected: ((_ index: Int, _ title: String) -> Void)?

    lazy var messageViewHeight = self.messageView.heightAnchor.constraint(equalToConstant: 0)

    public func update(viewModel: ALKMessageViewModel, maxWidth: CGFloat) {
        super.update(
            viewModel: viewModel,
            messageStyle: ALKMessageStyle.receivedMessage,
            mentionStyle: ALKMessageStyle.receivedMention
        )
        
        if viewModel.isReplyMessage {
            guard
                let metadata = viewModel.metadata,
                let replyId = metadata[AL_MESSAGE_REPLY_KEY] as? String,
                let actualMessage = getMessageFor(key: replyId)
            else { return }
            showReplyView(true)
            if actualMessage.messageType == .text || actualMessage.messageType == .html {
                previewImageView.constraint(withIdentifier: ConstraintIdentifier.PreviewImage.height)?.constant = 0
            } else {
                previewImageView.constraint(withIdentifier: ConstraintIdentifier.PreviewImage.width)?.constant = Padding.PreviewImageView.width
            }
        } else {
            showReplyView(false)
        }

        let placeHolder = UIImage(named: "placeholder", in: Bundle.applozic, compatibleWith: nil)
        if let url = viewModel.avatarURL {
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            avatarImageView.kf.setImage(with: resource, placeholder: placeHolder)
        } else {
            avatarImageView.image = placeHolder
        }

        nameLabel.text = viewModel.displayName
        
        guard let suggestedReplies = viewModel.suggestedReply() else {
            quickReplyView.isHidden = true
            return
        }
       
        let quickReplyViewWidth = maxWidth -
            (ChatCellPadding.ReceivedMessage.QuickReply.left + ChatCellPadding.ReceivedMessage.Message.right + Padding.AvatarImage.leading + Padding.AvatarImage.width + ChatCellPadding.ReceivedMessage.Message.left)
        quickReplyView.update(model: suggestedReplies, maxWidth: quickReplyViewWidth)
    }

    public class func rowHeight(
        viewModel: ALKMessageViewModel,
        width: CGFloat,
        displayNames: ((Set<String>) -> ([String: String]?))?
    ) -> CGFloat {
        let minimumHeight = Padding.AvatarImage.top + Padding.AvatarImage.height + 5
        /// Calculating available width for messageView
        let leftSpacing = Padding.AvatarImage.leading + Padding.AvatarImage.width + Padding.BubbleView.leading + bubbleViewLeftPadding
        let rightSpacing = Padding.BubbleView.trailing + ALKMessageStyle.receivedBubble.widthPadding
        let messageWidth = width - (leftSpacing + rightSpacing)
        let timeLabelSize = viewModel.time!.rectWithConstrainedWidth(
            Padding.TimeLabel.maxWidth,
            font: ALKMessageStyle.time.font
        )
        /// Calculating messageHeight
        let messageHeight = super
            .messageHeight(
                viewModel: viewModel,
                width: messageWidth,
                font: ALKMessageStyle.receivedMessage.font,
                mentionStyle: ALKMessageStyle.receivedMention,
                displayNames: displayNames
            )
        let heightPadding = Padding.NameLabel.top + Padding.NameLabel.height + Padding.ReplyView.top + Padding.MessageView.top + Padding.MessageView.bottom + Padding.BubbleView.bottom +
            timeLabelSize.height.rounded(.up) + Padding.TimeLabel.bottom

        let totalHeight = max(messageHeight + heightPadding, minimumHeight)
        
        guard let suggestedReplies = viewModel.suggestedReply() else {
            return totalHeight
        }

        let quickReplyPadding = ChatCellPadding.ReceivedMessage.QuickReply.left + ChatCellPadding.ReceivedMessage.Message.right
        let quickReplyViewWidth: CGFloat = width -
            (quickReplyPadding + Padding.AvatarImage.leading + Padding.AvatarImage.width + ChatCellPadding.ReceivedMessage.Message.left)
        return totalHeight
            + SuggestedReplyView.rowHeight(model: suggestedReplies, maxWidth: quickReplyViewWidth)
            + ChatCellPadding.ReceivedMessage.QuickReply.top
            + ChatCellPadding.ReceivedMessage.QuickReply.bottom
    }

    override func setupViews() {
        super.setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTappedAction))
        avatarImageView.addGestureRecognizer(tapGesture)

        contentView.addViewsForAutolayout(views: [quickReplyView, nameLabel, avatarImageView])
        contentView.bringSubviewToFront(messageView)
        quickReplyView.delegate = self

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Padding.NameLabel.top
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Padding.NameLabel.leading
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Padding.NameLabel.trailing
            ),
            nameLabel.heightAnchor.constraint(equalToConstant: Padding.NameLabel.height),

            avatarImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Padding.AvatarImage.top
            ),
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Padding.AvatarImage.leading
            ),
            avatarImageView.heightAnchor.constraint(equalToConstant: Padding.AvatarImage.height),
            avatarImageView.widthAnchor.constraint(equalToConstant: Padding.AvatarImage.width),

            emailBottomViewHeight,
            emailBottomView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor
            ),
            emailBottomView.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor
            ),

            bubbleView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            bubbleView.bottomAnchor.constraint(
                equalTo: emailBottomView.topAnchor,
                constant: -Padding.BubbleView.bottom
            ),
            bubbleView.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: Padding.BubbleView.leading
            ),
            bubbleView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -Padding.BubbleView.trailing
            ),
            
            replyView.topAnchor.constraint(
                equalTo: bubbleView.topAnchor,
                constant: Padding.ReplyView.top
            ),
            replyView.heightAnchor.constraintEqualToAnchor(
                constant: 0,
                identifier: ConstraintIdentifier.replyViewHeightIdentifier
            ),
            replyView.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor,
                constant: Padding.ReplyView.leading
            ),
            replyView.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor,
                constant: -Padding.ReplyView.trailing
            ),

            previewImageView.topAnchor.constraint(
                equalTo: replyView.topAnchor,
                constant: Padding.PreviewImageView.top
            ),
            previewImageView.trailingAnchor.constraint(
                lessThanOrEqualTo: replyView.trailingAnchor,
                constant: -Padding.PreviewImageView.trailing
            ),
            previewImageView.heightAnchor.constraintEqualToAnchor(
                constant: 0,
                identifier: ConstraintIdentifier.PreviewImage.height
            ),
            previewImageView.widthAnchor.constraintEqualToAnchor(
                constant: 0,
                identifier: ConstraintIdentifier.PreviewImage.width
            ),

            replyNameLabel.leadingAnchor.constraint(equalTo: replyView.leadingAnchor),
            replyNameLabel.topAnchor.constraint(equalTo: replyView.topAnchor),
            replyNameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: previewImageView.leadingAnchor,
                constant: -Padding.ReplyNameLabel.trailing
            ),
            replyNameLabel.heightAnchor.constraintEqualToAnchor(
                constant: 0,
                identifier: ConstraintIdentifier.ReplyNameLabel.height
            ),

            replyMessageLabel.leadingAnchor.constraint(equalTo: replyView.leadingAnchor),
            replyMessageLabel.topAnchor.constraint(
                equalTo: replyNameLabel.bottomAnchor,
                constant: Padding.ReplyMessageLabel.top
            ),
            replyMessageLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: previewImageView.leadingAnchor,
                constant: -Padding.ReplyMessageLabel.trailing
            ),
            replyMessageLabel.heightAnchor.constraintEqualToAnchor(
                constant: 0,
                identifier: ConstraintIdentifier.ReplyMessageLabel.height
            ),

            emailTopView.topAnchor.constraint(
                equalTo: replyView.bottomAnchor,
                constant: Padding.MessageView.top
            ),
            emailTopView.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor,
                constant: -ALKMessageStyle.receivedBubble.widthPadding
            ),
            emailTopView.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor,
                constant: ALKFriendMessageCell.bubbleViewLeftPadding
            ),
            emailTopHeight,

            messageView.topAnchor.constraint(
                equalTo: emailTopView.bottomAnchor
            ),
            messageView.bottomAnchor.constraint(
                equalTo: bubbleView.bottomAnchor,
                constant: -Padding.MessageView.bottom
            ),
            messageView.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor,
                constant: -ALKMessageStyle.receivedBubble.widthPadding
            ),
            messageView.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor,
                constant: ALKFriendMessageCell.bubbleViewLeftPadding
            ),

            quickReplyView.topAnchor.constraint(
                equalTo: bubbleView.bottomAnchor,
                constant: ChatCellPadding.ReceivedMessage.QuickReply.top
            ),
            quickReplyView.bottomAnchor.constraint(
                equalTo: timeLabel.topAnchor,
                constant: -ChatCellPadding.ReceivedMessage.QuickReply.bottom
            ),
            quickReplyView.leadingAnchor.constraint(
                equalTo: messageView.leadingAnchor,
                constant: ChatCellPadding.ReceivedMessage.QuickReply.left
            ),
            quickReplyView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -ChatCellPadding.ReceivedMessage.Message.right
            ),
            
            timeLabel.leadingAnchor.constraint(
                equalTo: quickReplyView.leadingAnchor,
                constant: Padding.TimeLabel.leading
            ),
            timeLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -1 * Padding.TimeLabel.bottom
            ),
            timeLabelWidth,
            timeLabelHeight
        ])
    }
    
    @objc private func avatarTappedAction() {
        avatarTapped?()
    }
    
    override func setupStyle() {
        super.setupStyle()

        nameLabel.setStyle(ALKMessageStyle.displayName)
        messageView.setStyle(ALKMessageStyle.receivedMessage)
        bubbleView.setStyle(ALKMessageStyle.receivedBubble, isReceiverSide: true)
    }
    private func showReplyView(_ show: Bool) {
        replyView
            .constraint(withIdentifier: ConstraintIdentifier.replyViewHeightIdentifier)?
            .constant = show ? Padding.ReplyView.height : 0
        replyNameLabel
            .constraint(withIdentifier: ConstraintIdentifier.ReplyNameLabel.height)?
            .constant = show ? Padding.ReplyNameLabel.height : 0
        replyMessageLabel
            .constraint(withIdentifier: ConstraintIdentifier.ReplyMessageLabel.height)?
            .constant = show ? Padding.ReplyMessageLabel.height : 0
        previewImageView
            .constraint(withIdentifier: ConstraintIdentifier.PreviewImage.height)?
            .constant = show ? Padding.PreviewImageView.height : 0
        previewImageView
            .constraint(withIdentifier: ConstraintIdentifier.PreviewImage.width)?
            .constant = show ? Padding.PreviewImageView.width : 0

        replyView.isHidden = !show
        replyNameLabel.isHidden = !show
        replyMessageLabel.isHidden = !show
        previewImageView.isHidden = !show
    }
}

extension ALKFriendMessageQuickReplyCell: Tappable {
    public func didTap(index: Int?, title: String) {
        guard let quickReplySelected = quickReplySelected, let index = index else { return }
        quickReplySelected(index, title)
    }
}
