//
//  ALKFriendVoiceCell.swift
//  ApplozicSwift
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class ALKFriendVoiceCell: ALKVoiceCell {

    lazy var  avatarImageViewBottom = avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)

    private var avatarImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        let layer = imv.layer
        layer.cornerRadius = 18.5
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        imv.isUserInteractionEnabled = true
        return imv
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override class func topPadding() -> CGFloat {
        return 28
    }

    override class func  rowHeight(viewModel: ALKMessageViewModel, width: CGFloat, isNameHide: Bool, isProfileHide: Bool) -> CGFloat{
        var height: CGFloat = Padding.RecivedHeightPadding.defaultHeightPadding
        if ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.round{
            if(isProfileHide && !isNameHide || (!isProfileHide && isNameHide) || !isProfileHide && !isNameHide ){
                height = Padding.RecivedHeightPadding.height
            }
        }else{
            height = 40
        }

        return topPadding()+height+bottomPadding()

    }

    override func setupStyle() {
        super.setupStyle()
        
        nameLabel.setStyle(ALKMessageStyle.displayName)
    }
    
    override func setupViews() {
        super.setupViews()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTappedAction))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        contentView.addViewsForAutolayout(views: [avatarImageView,nameLabel])
        
        bubbleView.backgroundColor = UIColor.hex8(Color.Background.grayF2.rawValue).withAlphaComponent(0.26)
        
        let width = UIScreen.main.bounds.width

        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.edge){
            soundPlayerViewBottom.constant = -6
        }
        soundPlayerViewBottom.isActive = true;
        soundPlayerView.widthAnchor.constraint(equalToConstant: width*0.48).isActive = true

        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.edge){
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18).isActive = true
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 0)
        }else{
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.5).isActive = true
            avatarImageViewBottom.isActive = true
        }

        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 57).isActive = true
        
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: soundPlayerView.topAnchor, constant: -6).isActive = true
        nameLabel.heightAnchor.constraintEqualToAnchor(constant: 0, identifier: ConstraintIdentifier.memberNameHeightIdentifier.rawValue).isActive = true
        
        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: soundPlayerView.leadingAnchor, constant: -10).isActive = true
        
        avatarImageView.heightAnchor.constraint(equalToConstant: 37).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
        
        timeLabel.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 2).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -2).isActive = true
    }
    
    override func update(viewModel: ALKMessageViewModel) {
        super.update(viewModel: viewModel)

        avatarImageView.isHidden = isHideProfilePicOrTimeLabel
        timeLabel.isHidden = isHideProfilePicOrTimeLabel
        nameLabel.isHidden = isHideMemberName

        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.round){
            if(!isHideProfilePicOrTimeLabel){
                soundPlayerViewBottom.constant = Padding.SoundPlayerView.bottomUnClubedPadding
            }else{
                soundPlayerViewBottom.constant = Padding.SoundPlayerView.bottomClubedPadding
            }
            avatarImageViewBottom.constant = Padding.AvatarImageView.bottomClubedPadding
        }

        if(!isHideProfilePicOrTimeLabel){
            let placeHolder = UIImage(named: "placeholder", in: Bundle.applozic, compatibleWith: nil)

            if let url = viewModel.avatarURL {

                let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                self.avatarImageView.kf.setImage(with: resource, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
            } else {

                self.avatarImageView.image = placeHolder
            }
        }

        if(!isHideMemberName){
            nameLabel.constraint(withIdentifier:ConstraintIdentifier.memberNameHeightIdentifier.rawValue)?.constant = 16
            nameLabel.text = viewModel.displayName
        }else{
            nameLabel.constraint(withIdentifier: ConstraintIdentifier.memberNameHeightIdentifier.rawValue)?.constant = 0

        }
     }
    
    override class func bottomPadding() -> CGFloat {
        return 6
    }

    @objc private func avatarTappedAction() {
        avatarTapped?()
    }
}



