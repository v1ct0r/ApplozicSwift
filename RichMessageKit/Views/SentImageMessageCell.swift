//
//  SentImageMessageView.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 20/05/19.
//

import UIKit

public class SentImageMessageCell: UITableViewCell {
    // MARK: - Public properties

    /// It is used to inform the delegate that the image is tapped. URL of tapped image is sent.
    public var delegate: Tappable?

    public enum Config {
        public static var maxWidth = UIScreen.main.bounds.width

        public struct MessageView {
            /// Left padding of `MessageView`
            public static var leftPadding: CGFloat = 60.0
            /// Bottom padding of `MessageView`
            public static var rightPadding: CGFloat = 10.0
            public static var topPadding: CGFloat = 10.0
        }

        public enum StateView {
            public static var width: CGFloat = 17.0
            public static var height: CGFloat = 9.0
            public static var leftPadding: CGFloat = 2.0
            public static var rightPadding: CGFloat = 2.0
            public static var topPadding: CGFloat = 5
        }

        public enum TimeLabel {
            /// Left padding of `TimeLabel` from `StateView`
            public static var leftPadding: CGFloat = 2.0
            public static var maxWidth: CGFloat = 200.0
            public static var rightPadding: CGFloat = 2.0
            public static var topPadding: CGFloat = 2.0
        }

        public enum ImageBubbleView {
            public static var topPadding: CGFloat = 2.0
            public static var rightPadding: CGFloat = 10
            public static var bottomPadding: CGFloat = 10
        }
    }

    // MARK: - Fileprivate properties

    fileprivate var timeLabel: UILabel = {
        let lb = UILabel()
        lb.setStyle(MessageTheme.sentMessage.time)
        lb.isOpaque = true
        return lb
    }()

    fileprivate var stateView: UIImageView = {
        let sv = UIImageView()
        sv.isUserInteractionEnabled = false
        sv.contentMode = .center
        return sv
    }()

    fileprivate lazy var timeLabelWidth = timeLabel.widthAnchor.constraint(equalToConstant: 0)
    fileprivate lazy var timeLabelHeight = timeLabel.heightAnchor.constraint(equalToConstant: 0)

    fileprivate lazy var messageView = MessageView(
        bubbleStyle: MessageTheme.sentMessage.bubble,
        messageStyle: MessageTheme.sentMessage.message,
        maxWidth: Config.maxWidth
    )
    fileprivate var messageViewPadding: Padding
    fileprivate var imageBubble: ImageContainer
    fileprivate var imageBubbleWidth: CGFloat
    fileprivate lazy var messageViewHeight = messageView.heightAnchor.constraint(equalToConstant: 0)

    fileprivate lazy var imageBubbleHeight = imageBubble.heightAnchor.constraint(equalToConstant: 0)

    fileprivate var imageUrl: String?

    // MARK: - Initializer

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        messageViewPadding = Padding(left: Config.MessageView.leftPadding,
                                     right: Config.MessageView.rightPadding,
                                     top: Config.MessageView.topPadding,
                                     bottom: Config.ImageBubbleView.topPadding)
        imageBubble = ImageContainer(frame: .zero, maxWidth: Config.maxWidth, isMyMessage: true)
        imageBubbleWidth = Config.maxWidth * ImageBubbleTheme.sentMessage.widthRatio
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupGesture()
        backgroundColor = .clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Updates the `ImageMessageView`.
    ///
    /// - Parameter model: object that conforms to `ImageMessage`
    public func update(model: ImageMessage) {
        guard model.message.isMyMessage else {
            print("😱😱😱Inconsistent information passed to the view.😱😱😱")
            print("For SentMessage value of isMyMessage should be true")
            return
        }
        let isMessageEmpty = model.message.isMessageEmpty()

        messageViewHeight.constant = isMessageEmpty ? 0 : SentMessageViewSizeCalculator().rowHeight(messageModel: model.message, maxWidth: Config.maxWidth, padding: messageViewPadding)

        if !isMessageEmpty {
            messageView.update(model: model.message.text ?? "")
        }

        messageView.updateHeighOfView(hideView: isMessageEmpty, model: model.message.text ?? "")

        imageBubbleHeight.constant = ImageBubbleSizeCalculator().rowHeight(model: model, maxWidth: Config.maxWidth)

        // Set time and update timeLabel constraint.
        timeLabel.text = model.message.time
        let timeLabelSize = model.message.time.rectWithConstrainedWidth(Config.TimeLabel.maxWidth,
                                                                        font: MessageTheme.sentMessage.time.font)
        timeLabelHeight.constant = timeLabelSize.height.rounded(.up)
        timeLabelWidth.constant = timeLabelSize.width.rounded(.up) // This is amazing😱😱😱... a diff in fraction can trim.
        layoutIfNeeded()

        /// Set frame
        let height = SentImageMessageCell.rowHeight(model: model)
        frame.size = CGSize(width: Config.maxWidth, height: height)

        imageUrl = model.url
        imageBubble.update(model: model)

        guard let status = model.message.status else { return }
        // Set status
        var statusImage = MessageTheme.sentMessage.status
        switch status {
        case .pending:
            statusImage.pending = statusImage.pending?.withRenderingMode(.alwaysTemplate)
            stateView.image = statusImage.pending
            stateView.tintColor = UIColor.red
        case .sent:
            stateView.image = statusImage.sent
        case .delivered:
            stateView.image = statusImage.delivered
        case .read:
            statusImage.read = statusImage.read?.withRenderingMode(.alwaysTemplate)
            stateView.image = statusImage.read
            stateView.tintColor = UIColor(netHex: 0x0578FF)
        }
    }

    /// It is used to get exact height of `ImageMessageView` using messageModel, width and padding
    ///
    /// - NOTE: Font is not used. Change `ImageBubbleStyle.captionStyle.font`
    /// - Parameters:
    ///   - model: object that conforms to `ImageMessage`
    /// - Returns: exact height of the view.
    public static func rowHeight(model: ImageMessage) -> CGFloat {
        return ImageMessageViewSizeCalculator().rowHeight(model: model, maxWidth: Config.maxWidth)
    }

    private func setupConstraints() {
        addViewsForAutolayout(views: [messageView, imageBubble, timeLabel, stateView])

        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: Config.MessageView.topPadding),
            messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * Config.MessageView.rightPadding),
            messageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Config.MessageView.leftPadding),
            messageViewHeight,

            imageBubble.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: Config.ImageBubbleView.topPadding),
            imageBubble.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * Config.ImageBubbleView.rightPadding),
            imageBubble.widthAnchor.constraint(equalToConstant: imageBubbleWidth),

            imageBubbleHeight,
            stateView.widthAnchor.constraint(equalToConstant: Config.StateView.width),
            stateView.heightAnchor.constraint(equalToConstant: Config.StateView.height),
            stateView.topAnchor.constraint(equalTo: imageBubble.bottomAnchor, constant: Config.StateView.topPadding),
            stateView.leadingAnchor.constraint(greaterThanOrEqualTo: imageBubble.leadingAnchor, constant: Config.StateView.leftPadding),
            stateView.trailingAnchor.constraint(equalTo: imageBubble.trailingAnchor, constant: -1 * Config.StateView.rightPadding),

            timeLabel.topAnchor.constraint(equalTo: imageBubble.bottomAnchor, constant: Config.TimeLabel.topPadding),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: stateView.leadingAnchor, constant: Config.TimeLabel.leftPadding),
            timeLabelWidth,
            timeLabelHeight,
            timeLabel.trailingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: -1 * Config.TimeLabel.rightPadding),
        ])
    }

    @objc private func imageTapped() {
        guard let delegate = delegate else {
            print("❌❌❌ Delegate is not set. To handle image click please set delegate.❌❌❌")
            return
        }
        guard let imageUrl = imageUrl else {
            print("😱😱😱 ImageUrl is found nil. 😱😱😱")
            return
        }
        delegate.didTap(index: 0, title: imageUrl)
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.numberOfTapsRequired = 1
        imageBubble.addGestureRecognizer(tapGesture)
    }
}
