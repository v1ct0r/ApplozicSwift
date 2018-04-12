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
        
        soundPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        soundPlayerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 48).isActive = true
        soundPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39).isActive = true
        soundPlayerView.widthAnchor.constraint(equalToConstant: width*0.48).isActive = true
        soundPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
        let image = UIImage.init(named: "chat_bubble_red", in: Bundle.applozic, compatibleWith: nil)
        bubbleView.image = image?.imageFlippedForRightToLeftLayoutDirection()
        bubbleView.tintColor =   UIColor(red: 92.0 / 255.0, green: 90.0 / 255.0, blue:167.0 / 255.0, alpha: 1.0)
        
        stateView.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        stateView.heightAnchor.constraint(equalToConstant: 9.0).isActive = true
        stateView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -1.0).isActive = true
        stateView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 13).isActive = true

        timeLabel.trailingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: -6.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -3).isActive = true
    }
    
    override func update(viewModel: ALKMessageViewModel) {
        super.update(viewModel: viewModel)
        
      
        if viewModel.isAllRead {
            stateView.image = UIImage(named: "kmreadIcon", in: Bundle.applozic, compatibleWith: nil)
        } else if viewModel.isAllReceived {
            stateView.image = UIImage(named: "kmdeliveredIcon", in: Bundle.applozic, compatibleWith: nil)
            stateView.tintColor = nil
        } else if viewModel.isSent {
            stateView.image = UIImage(named: "kmsenticon", in: Bundle.applozic, compatibleWith: nil)
            stateView.tintColor = nil
        } else {
            stateView.image = UIImage(named: "seen_state_0", in: Bundle.applozic, compatibleWith: nil)
            stateView.tintColor = UIColor.red
        }
    }
    
    override class func bottomPadding() -> CGFloat {
        return 25
    }
    
}
