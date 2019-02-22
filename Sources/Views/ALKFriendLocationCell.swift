//
//  ALKFriendLocationCell.swift
//  
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import UIKit
import Kingfisher

final class ALKFriendLocationCell: ALKLocationCell {

    lazy var  avatarImageViewBottom = avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 0)
    // MARK: - Declare Variables or Types
    // MARK: Environment in chat
    private var avatarImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        let layer = imv.layer
        layer.cornerRadius = 18.5
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        return imv
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    override func setupViews() {
        super.setupViews()
        
        bubbleView.backgroundColor = .background(.grayF2)
        
        // add view to contenview and setup constraint
        contentView.addViewsForAutolayout(views: [avatarImageView,nameLabel])

        
        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.edge){
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 0).isActive = true
        }else{
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.5).isActive = true
            avatarImageViewBottom.isActive = true
        }
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 57.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56.0).isActive = true
        nameLabel.heightAnchor.constraintEqualToAnchor(constant: 0, identifier: ConstraintIdentifier.memberNameHeightIdentifier.rawValue).isActive = true

        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18.0).isActive = true

        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9.0).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 37.0).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true

        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.edge){
            bubbleViewBottom.constant = -6.0
            bubbleView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6.0).isActive = true
        }else{
            bubbleView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true

        }
        bubbleViewBottom.isActive = true
        
        bubbleView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10.0).isActive = true
        
        timeLabel.leadingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 2.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2.0).isActive = true
    }
    
    override func setupStyle() {
        super.setupStyle()
        nameLabel.setStyle(ALKMessageStyle.displayName)
    }
    
    override func update(viewModel: ALKMessageViewModel) {
        super.update(viewModel: viewModel)

        avatarImageView.isHidden = isHideProfilePicOrTimeLabel
        timeLabel.isHidden = isHideProfilePicOrTimeLabel
        nameLabel.isHidden = isHideMemberName

        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.round){
            if(!isHideProfilePicOrTimeLabel){
                bubbleViewBottom.constant = -Padding.BubbleView.bottomUnClubedPadding
            }else{
                bubbleViewBottom.constant = -Padding.BubbleView.bottomClubedPadding
            }
            avatarImageViewBottom.constant = bubbleViewBottom.constant
        }

        if(!isHideProfilePicOrTimeLabel){
            let placeHolder = UIImage(named: "placeholder", in: Bundle.applozic, compatibleWith: nil)

            if let url = viewModel.avatarURL {
                let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                avatarImageView.kf.setImage(with: resource, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                avatarImageView.image = placeHolder
            }
        }

        if(!isHideMemberName){
            nameLabel.constraint(withIdentifier: ConstraintIdentifier.memberNameHeightIdentifier.rawValue)?.constant = 16
            nameLabel.text = viewModel.displayName
        }else{
            nameLabel.constraint(withIdentifier: ConstraintIdentifier.memberNameHeightIdentifier.rawValue)?.constant = 0

        }

    }

    override class func  rowHeight(viewModel: ALKMessageViewModel, width: CGFloat, isNameHide: Bool, isProfileHide: Bool) -> CGFloat{

        return super.rowHeight(viewModel: viewModel, width: width, isNameHide: isNameHide, isProfileHide: isProfileHide) + 34.0
    }

   override func setMessageModels(namelabelFlag: Bool,profilePicFlag: Bool){
        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.round){
            isHideProfilePicOrTimeLabel = profilePicFlag
            isHideMemberName = namelabelFlag
        }
   }

}
