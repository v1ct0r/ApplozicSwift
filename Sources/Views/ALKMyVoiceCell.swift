//
//  ALKMyVoiceCell.swift
//  ApplozicSwift
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import Foundation

import UIKit
import Foundation
import Kingfisher
import AVFoundation

class ALKMyVoiceCell: ALKVoiceCell {
    
    fileprivate var stateView: UIImageView = {
        let sv = UIImageView()
        sv.isUserInteractionEnabled = false
        sv.contentMode = .center
        return sv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        let width = UIScreen.main.bounds.width
        
        contentView.addViewsForAutolayout(views: [stateView])
        
        soundPlayerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 48).isActive = true
        soundPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14).isActive = true
        soundPlayerView.widthAnchor.constraint(equalToConstant: width*0.48).isActive = true

        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.edge){
            soundPlayerViewBottom.constant = -6
            soundPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true

        }else{
            soundPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        }
        soundPlayerViewBottom.isActive = true
        bubbleView.backgroundColor = UIColor.hex8(Color.Background.grayF2.rawValue).withAlphaComponent(0.26)
        
        stateView.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        stateView.heightAnchor.constraint(equalToConstant: 9.0).isActive = true
        stateView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -1.0).isActive = true
        stateView.trailingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -2.0).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: -2.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0).isActive = true
    }

    override class func  rowHeight(viewModel: ALKMessageViewModel, width: CGFloat, isNameHide: Bool, isProfileHide: Bool) -> CGFloat{
        var height: CGFloat = Padding.SentHeightPadding.defaultHeightPadding
        if ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.round{
            if(!isProfileHide){
                height =  Padding.SentHeightPadding.timeHiddenPadding
            }
        }else{
            height = Padding.SentHeightPadding.defaultHeightPadding
        }

        return topPadding()+height+bottomPadding()
    }

    override func update(viewModel: ALKMessageViewModel) {
        super.update(viewModel: viewModel)

        timeLabel.isHidden = isHideProfilePicOrTimeLabel

        if(ALKMessageStyle.receivedBubble.style == ALKMessageStyle.BubbleStyle.round){
            if(!isHideProfilePicOrTimeLabel){
                soundPlayerViewBottom.constant = -Padding.SoundPlayerView.bottomUnClubedPadding
            }else{
                soundPlayerViewBottom.constant = -Padding.SoundPlayerView.bottomClubedPadding
            }
        }

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
    }
    
    override class func bottomPadding() -> CGFloat {
        return 6
    }
    
}
