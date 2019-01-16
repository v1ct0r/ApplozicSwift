//
//  ALKBaseCell.swift
//  ApplozicSwift
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import Foundation
import UIKit

open class ALKBaseCell<T>: UITableViewCell {
    
    public enum ConstraintIdentifier: String {
        case replyViewHeightIdentifier = "ReplyViewHeight"
        case replyNameHeightIdentifier = "ReplyNameHeight"
        case replyMessageHeightIdentifier = "ReplyMessageHeight"
        case replyPreviewImageHeightIdentifier = "ReplyPreviewImageHeight"
        case replyPreviewImageWidthIdentifier = "ReplyPreviewImageWidth"
        case memberNameHeightIdentifier = "GroupMemeberNameHeight"
        case messageViewBottomIdentifier = "MessageViewBottomPadding"

    }

    var viewModel: T?
    var index:Int = 0
    var  messageModels:[ALKMessageModel]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
    }
    
    func setupStyle(){
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func update(viewModel: T) {
        self.viewModel = viewModel
    }

    func setMessageModels(messageModels:[ALKMessageModel],index:Int,namelabelFlag: Bool,profilePicFlag: Bool){

        self.messageModels = messageModels;
        self.index = index
    }
    
    class func rowHeigh(viewModel: T,width: CGFloat) -> CGFloat {
        return 44
    }

    class  func rowHeight(viewModel: T,width: CGFloat,isNameHide:Bool,isProfileHide:Bool) -> CGFloat{
        return 40
    }
    
}
