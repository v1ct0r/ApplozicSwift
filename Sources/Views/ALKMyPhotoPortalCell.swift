//
//  ALKMyPhotoPortalCell.swift
//  ApplozicSwift
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import Foundation

// MARK: - ALKMyPhotoPortalCell
final class ALKMyPhotoPortalCell: ALKPhotoCell {

    enum state {
        case upload
        case uploading
        case uploaded
    }
    
    fileprivate var stateView: UIImageView = {
        let sv = UIImageView()
        sv.isUserInteractionEnabled = false
        sv.contentMode = .center
        return sv
    }()

    struct Padding {
        struct PhotoView {
            static let right: CGFloat = 14
            static let top: CGFloat = 6
        }
    }

    override class var messageTextFont: UIFont {
        return ALKMessageStyle.sentMessage.font
    }

    override func setupViews() {
        super.setupViews()

        contentView.addViewsForAutolayout(views: [stateView])
        
        photoView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: Padding.PhotoView.top)
            .isActive = true

        photoView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -Padding.PhotoView.right)
            .isActive = true

        photoView.widthAnchor
            .constraint(equalToConstant: ALKPhotoCell.maxWidth*ALKPhotoCell.widthPercentage)
            .isActive = true
        photoView.heightAnchor
            .constraint(equalToConstant: ALKPhotoCell.maxWidth*ALKPhotoCell.heightPercentage)
            .isActive = true

        bubbleView.backgroundColor = UIColor.hex8(Color.Background.grayF2.rawValue).withAlphaComponent(0.26)
        
        fileSizeLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 0).isActive = true
        
        stateView.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        stateView.heightAnchor.constraint(equalToConstant: 9.0).isActive = true
        stateView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -1.0).isActive = true
        stateView.trailingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -2.0).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: -2.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2).isActive = true
    }
    
    override func update(viewModel: ALKMessageViewModel) {
        super.update(viewModel: viewModel)

        if viewModel.isAllRead {
            stateView.image = UIImage(named: "read_state_3", in: Bundle.applozic, compatibleWith: nil)
            stateView.tintColor = UIColor(netHex: 0x0578FF)
        } else if viewModel.isAllReceived {
            stateView.image = UIImage(named: "read_state_2", in: Bundle.applozic, compatibleWith: nil)
            stateView.tintColor = nil
        } else if viewModel.isSent {
            stateView.image = UIImage(named: "read_state_1", in: Bundle.applozic, compatibleWith: nil)
            stateView.tintColor = nil
        } else {
            stateView.image = UIImage(named: "seen_state_0", in: Bundle.applozic, compatibleWith: nil)
            stateView.tintColor = UIColor.red
        }

        guard (viewModel.message != nil), let message = viewModel.message  else {
            return;
        }

        let attributes: [NSAttributedString.Key : Any] = [.font:ALKMessageStyle.sentMessage.font]
        let mutableText =  NSMutableAttributedString(string: message, attributes: attributes)
        mutableText.addAttributes(attributes, range: NSMakeRange(0,mutableText.length))
        self.captionLabel.attributedText = mutableText

    }

    override class func rowHeigh( viewModel: ALKMessageViewModel,
                                  width: CGFloat) -> CGFloat {
        var height: CGFloat

        height =  self.viewHeight(viewModel: viewModel, width: width, font: ALKMessageStyle.sentMessage.font)
        
        return topPadding()+height+bottomPadding()
    }

    override class func bottomPadding() -> CGFloat {
        return 16
    }

    override func setupStyle() {
        super.setupStyle()
        captionLabel.font = ALKMessageStyle.sentMessage.font
        captionLabel.textColor = ALKMessageStyle.sentMessage.text
        captionLabel.backgroundColor = ALKMessageStyle.sentMessage.background
        if(ALKMessageStyle.sentBubble.style == .edge){
            bubbleView.layer.cornerRadius = ALKMessageStyle.sentBubble.cornerRadius
            bubbleView.backgroundColor = ALKMessageStyle.sentBubble.color
            photoView.layer.cornerRadius = ALKMessageStyle.sentBubble.cornerRadius
        }else{
            photoView.layer.cornerRadius = ALKMessageStyle.sentBubble.cornerRadius
            bubbleView.layer.cornerRadius = ALKMessageStyle.sentBubble.cornerRadius
        }
    }
}
