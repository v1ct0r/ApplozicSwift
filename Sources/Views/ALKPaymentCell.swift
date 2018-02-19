//
//  ALKPaymentCell.swift
//  ApplozicSwift
//
//  Created by Sunil on 11/01/18.
//

import Kingfisher
import Foundation
import UIKit
import Applozic


public protocol ALKCustomAmountProtocol : class{
    func didAcceptCliked(paymentModel:ALKPaymentModel)
}

// MARK: - ALKPaymentCell
class ALKPaymentCell: ALKChatBaseCell<ALKMessageViewModel> {
    
    public var delegatePr: ALKCustomAmountProtocol?
    weak public var delegate: ALKConversationViewModelDelegate?
    
    
    
    var timeLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    
    fileprivate var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()
    
    
    fileprivate var bubbleView: UIImageView = {
        let bv = UIImageView()
        let image = UIImage.init(named: "chat_bubble_red", in: Bundle.applozic, compatibleWith: nil)
        bv.tintColor = UIColor(netHex: 0xF1F0F0)
        bv.isUserInteractionEnabled = true
        bv.image = image?.imageFlippedForRightToLeftLayoutDirection()
        bv.isOpaque = true
        return bv
    }()
    
    
    var paymentTitle: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.numberOfLines = 2
        lb.font = Font.bold(size: 12.0).font()
        
        lb.backgroundColor=UIColor.clear
        return lb
    }()
    
    
    var paymentMoney: UILabel = {
        let lb = UILabel()
        
        lb.textAlignment = .center
        lb.backgroundColor=UIColor.clear
        lb.font = Font.bold(size: 14.0).font()
        
        return lb
    }()
    
    
    var paymentSubjctTitle: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = Font.bold(size: 14.0).font()
        lb.backgroundColor = UIColor.clear
        
        return lb
    }()
    
    var paymentSubjctText: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = Font.bold(size: 14.0).font()
        lb.backgroundColor=UIColor.clear
        return lb
    }()
    
    
    
    fileprivate var paymentAceptButton: UIButton = {
        let button = UIButton()
        button .setTitle("Accept", for: UIControlState.normal)
        button.setTextColor(color: Color.Text.black00, forState:UIControlState.normal)
        
        return button
    }()
    
    
    fileprivate var paymentRejectButton: UIButton = {
        let button = UIButton(type: .custom)
        button .setTitle("Reject", for: UIControlState.normal)
        button.setTextColor(color: Color.Text.black00, forState:UIControlState.normal)
        return button
    }()
    
    
    
    fileprivate let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var uploadTapped:((Bool) ->())?
    
    var accpetButtonTapped:((Bool) ->())?
    
    var uploadCompleted: ((_ responseDict: Any?) ->())?
    
    var downloadTapped:((Bool) ->())?
    
    
    class func topPadding() -> CGFloat {
        return 12
    }
    
    class func bottomPadding() -> CGFloat {
        return 16
    }
    
    override class func rowHeigh(viewModel: ALKMessageViewModel,width: CGFloat) -> CGFloat {
        
        let heigh = (width*0.27)
        
        return topPadding()+heigh+bottomPadding()
    }
    
    
    var avatarImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        let layer = imv.layer
        layer.cornerRadius = 22.5
        layer.backgroundColor = UIColor.clear.cgColor
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
    
    
    
    
    var url: URL? = nil
    enum state {
        case upload(filePath: String)
        case uploading(filePath: String)
        case uploaded
        case download
        case downloading
        case downloaded(filePath: String)
    }
    
    override func update(viewModel: ALKMessageViewModel) {
        
        self.viewModel = viewModel
        activityIndicator.color = .black
        
        let placeHolder = UIImage(named: "placeholder", in: Bundle.applozic, compatibleWith: nil)
        
        if let url = viewModel.avatarURL {
            
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            self.avatarImageView.kf.setImage(with: resource, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            
            self.avatarImageView.image = placeHolder
        }
        
        nameLabel.text = viewModel.displayName
        
        var nsmutable =  viewModel.metadata
        
        if((nsmutable) != nil){
            let amount =     nsmutable!["amount"]
            let hiddenStatus =     nsmutable!["hiddenStatus"]
            let paymentId =     nsmutable!["paymentId"]
            let  paymentMessage = nsmutable!["paymentMessage"]
            let  paymentSubject = nsmutable!["paymentSubject"]
            let  paymentStatus = nsmutable!["paymentStatus"]
            let   richMessageType = nsmutable!["richMessageType"];
            let doller = "$"
            let amountString = "\(doller) \(amount as! String)"
            
            if(viewModel.isMyMessage){
                if(paymentStatus != nil && "paymentRequested"  ==  paymentStatus as! String!){
                    handlePaymentActionbuttonVisibality(isHidden: false)
                    paymentMoney.text = amountString
                    paymentTitle.text = "You requested from "+viewModel.displayName!
                }else if("paymentRejected" == paymentStatus as! String!){
                    
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:                  amountString)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                    paymentTitle.text = viewModel.displayName!+" rejected"
                    paymentMoney.attributedText = attributeString
                }else{
                    handlePaymentActionbuttonVisibality(isHidden: true)
                    paymentMoney.text = amountString
                    paymentTitle.text = "You paid to "+viewModel.displayName!
                }
            }else{
                if("paymentRequested"  ==  paymentStatus as! String!){
                    if(viewModel.channelKey != nil){
                        let  channelService = ALChannelDBService();
                        let  messageDb = ALMessageDBService();
                        let requestedString = viewModel.displayName! + " requested from "
                        
                        if(nsmutable!["paymentHeader"] == nil){
                            
                            let groupNames = channelService.string(fromChannelUserMetaData:NSMutableDictionary(dictionary: nsmutable!), paymentMessageTitle: true)
                            
                            nsmutable!["paymentHeader"] = groupNames
                            paymentTitle.text = requestedString + groupNames!
                            
                            let channeldb = messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable!))
                            
                        }else{
                            paymentTitle.text = requestedString + (nsmutable!["paymentHeader"] as? String)!
                        }
                        
                        let  paymentReceiver = nsmutable!["paymentReceiver"] as? String;
                        
                        if(paymentReceiver == nil){
                            
                            if (nsmutable![ALUserDefaultsHandler.getUserId()] != nil ){
                                handlePaymentActionbuttonVisibality(isHidden: true)
                                
                            }else{
                                let usersRequested = nsmutable!["usersRequested"] as? String;
                                
                                
                                let replacedString =   usersRequested?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]",with: "").replacingOccurrences(of: "\"",with: "")
                                
                                
                                let arary : [String] = replacedString!.components(separatedBy: ",")
                                
                                if arary.contains(ALUserDefaultsHandler.getUserId()){
                                    handlePaymentActionbuttonVisibality(isHidden: false)
                                }else{
                                    handlePaymentActionbuttonVisibality(isHidden: true)
                                }
                            }
                            
                            
                        }else if (nsmutable![ALUserDefaultsHandler.getUserId()] != nil ){
                            handlePaymentActionbuttonVisibality(isHidden: true)
                        }else{
                            handlePaymentActionbuttonVisibality(isHidden: true)
                        }
                        
                        
                        
                    }else if(viewModel.contactId != nil){
                        paymentTitle.text = viewModel.displayName! + " requested from You "
                        handlePaymentActionbuttonVisibality(isHidden: false)
                        
                    }
                    
                    paymentMoney.text = amountString
                }else if("paymentRejected" == paymentStatus as! String!){
                    
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:  amountString)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                    handlePaymentActionbuttonVisibality(isHidden: true)
                    paymentMoney.attributedText = attributeString
                    
                    if(viewModel.channelKey != nil){
                        
                        let  channelService = ALChannelDBService();
                        let  messageDb = ALMessageDBService();
                        if(nsmutable!["paymentHeader"] == nil){
                            
                            let paymentReceiver =   nsmutable!["paymentReceiver"] as? String
                            
                            if(paymentReceiver != nil){
                                let contactDataBase = ALContactDBService()
                                
                                let contact =  contactDataBase.loadContact(byKey: "userId", value: paymentReceiver);
                                if(contact != nil){
                                    var groupNames : String  = " ";
                                    if(ALUserDefaultsHandler.getUserId()  == contact?.userId){
                                        groupNames  = viewModel.displayName! + " rejected " + " your payment"
                                        
                                    }else{
                                        groupNames  = viewModel.displayName! + " rejected " + (contact?.getDisplayName())! + "'s" + " payment"
                                    }
                                    
                                    nsmutable!["paymentHeader"] = groupNames
                                    paymentTitle.text = groupNames
                                    
                                    let channeldb = messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable!) )
                                }
                                
                                
                            }
                        }else{
                            
                            paymentTitle.text =  (nsmutable!["paymentHeader"] as? String)!
                        }
                        
                        
                    }else{
                        paymentTitle.text = "You rejected"
                    }
                    
                    
                }else if("paymentAccepted" == paymentStatus as! String!){
                    paymentMoney.text = amountString
                    handlePaymentActionbuttonVisibality(isHidden: true)
                    paymentTitle.text = viewModel.displayName! + " paid you"
                }else{
                    let requestedString = viewModel.displayName! + " paid "
                    
                    
                    if(viewModel.channelKey != nil){
                        let  channelService = ALChannelDBService();
                        let  messageDb = ALMessageDBService();
                        
                        if(nsmutable!["paymentHeader"] == nil){
                            
                            
                            let groupNames = channelService.string(fromChannelUserMetaData:NSMutableDictionary(dictionary: nsmutable!), paymentMessageTitle: true)
                            
                            nsmutable!["paymentHeader"] = groupNames
                            paymentTitle.text = requestedString + groupNames!
                            
                            let channeldb = messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable!)  )
                            
                        }else{
                            
                            paymentTitle.text =   requestedString + (nsmutable!["paymentHeader"] as? String)!
                        }
                        
                        handlePaymentActionbuttonVisibality(isHidden: true)
                        
                    }else if(viewModel.contactId != nil){
                        paymentTitle.text = viewModel.displayName! + " paid you"
                        handlePaymentActionbuttonVisibality(isHidden: false)
                        
                    }
                    
                    paymentMoney.text = amountString
                    
                }
            }
            
            paymentSubjctTitle.text = "Asunto:"
            paymentSubjctText.text = paymentSubject as? String
        }
        
        
        timeLabel.text   = viewModel.time
        
    }
    
    
    func handlePaymentActionbuttonVisibality(isHidden: Bool) {
        paymentRejectButton.isHidden = isHidden;
        paymentAceptButton.isHidden = isHidden;
        
    }
    
    
    
    func actionTapped(button: UIButton) {
        let storyboard = UIStoryboard.name(storyboard: UIStoryboard.Storyboard.mediaViewer, bundle: Bundle.applozic)
        
        let nav = storyboard.instantiateInitialViewController() as? UINavigationController
        let vc = nav?.viewControllers.first as? ALKMediaViewerViewController
        let dbService = ALMessageDBService()
        guard let messages = dbService.getAllMessagesWithAttachment(forContact: viewModel?.contactId, andChannelKey: viewModel?.channelKey, onlyDownloadedAttachments: true) as? [ALMessage] else { return }
        
        let messageModels = messages.map { $0.messageModel }
        NSLog("Messages with attachment: ", messages )
        
        guard let viewModel = viewModel as? ALKMessageModel,
            let currentIndex = messageModels.index(of: viewModel) else { return }
        vc?.viewModel = ALKMediaViewerViewModel(messages: messageModels, currentIndex: currentIndex)
        
        UIViewController.topViewController()?.present(nav!, animated: true, completion: {
            button.isEnabled = true
        })
    }
    
    func actionAccept(button: UIButton) {
        
        if(viewModel?.channelKey != nil){
            let channelService = ALChannelDBService()
            if(channelService.isChannelLeft(viewModel?.channelKey)){
                print("User is not in group !")
                
            }else{
                processPaymentAccept()
                
            }
            
        }else{
            processPaymentAccept()
            
        }
        
    }
    
    
    func processPaymentAccept(){
        
        
        let viewController:ALKAmountPayController   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ALKAmountPayController") as UIViewController as! ALKAmountPayController
        let model  =  ALKPaymentModel();
        
        model.userId =  viewModel?.contactId
        model.messageKey =   viewModel?.identifier
        model.groupId =   viewModel?.channelKey
        viewController.paymentModleData = model
        
        UIViewController.topViewController()?.present(viewController, animated: true, completion: {
        })
        
    }
    
    
    func actionReject(button: UIButton) {
        
        if(viewModel?.channelKey != nil){
            let channelService = ALChannelDBService()
            if(channelService.isChannelLeft(viewModel?.channelKey)){
                print("User is not in group !")
            }else{
                processPaymentReject()
            }
            
        }else{
            processPaymentReject()
            
        }
        
    }
    
    
    func processPaymentReject(){
        
        
        
        var dictionaryMetadata = Dictionary<String, Any>();
        dictionaryMetadata =  (viewModel?.metadata)!
        
        let messageService = ALMessageService();
        let messagedb = ALMessageDBService();
        
        if( viewModel?.identifier != nil){
            
            let message = messagedb.getMessage("key", value:viewModel?.identifier);
            
            dictionaryMetadata["hiddenStatus"] = "false"
            
            let paymentId =  dictionaryMetadata["paymentId"]
            let  paymentMessage = dictionaryMetadata["paymentMessage"]
            let  paymentSubject = dictionaryMetadata["paymentSubject"]
            let  paymentStatus = dictionaryMetadata["paymentStatus"]
            let   richMessageType = dictionaryMetadata["richMessageType"]
            let   usersRequested = dictionaryMetadata["usersRequested"]
            
            if(dictionaryMetadata["paymentHeader"]  != nil){
                dictionaryMetadata.removeValue(forKey: "paymentHeader")
            }
            
            if(usersRequested == nil ){
                dictionaryMetadata["paymentStatus"] = "paymentRejected"
            }else{
                dictionaryMetadata[ALUserDefaultsHandler.getUserId()]  = "done"
            }
            
            if(message?.channelKey != nil){
                dictionaryMetadata["paymentReceiver"] = message?.to
            }
            
            
            messageService.updateMessageMetaData(viewModel?.identifier, withMessageMetaData: dictionaryMetadata as! NSMutableDictionary,withCompletionHandler:{
                apirespone, error in
                
                if((error == nil) ){
                    
                    let dbMessage = messagedb.getMessage("key", value:message?.key)
                    var nsmutableMeatdata = NSMutableDictionary();
                    nsmutableMeatdata =   (dbMessage?.metadata)!
                    let   usersRequestedArray = nsmutableMeatdata["usersRequested"]
                    
                    
                    if(nsmutableMeatdata["paymentStatus"] != nil &&  nsmutableMeatdata["paymentStatus"] as! String == "paymentRequested" && usersRequestedArray != nil){
                        
                        let message =  ALMessage();
                        
                        if(dbMessage?.groupId != nil){
                            message.groupId = dbMessage?.groupId
                        }else if(dbMessage?.contactId != nil){
                            message.contactIds = dbMessage?.contactId
                            message.to = dbMessage?.contactId
                        }
                        
                        message.key =  UUID().uuidString
                        let date = Date().timeIntervalSince1970*1000
                        message.createdAtTime = NSNumber(value: date)
                        message.sendToDevice = false
                        message.deviceKey = ALUserDefaultsHandler.getDeviceKeyString()
                        message.shared = false
                        message.fileMeta = nil
                        message.storeOnDevice = false
                        message.contentType = Int16(ALMESSAGE_RICH_MESSAGING)
                        message.type = "5"
                        message.source = Int16(SOURCE_IOS)
                        
                        nsmutableMeatdata["paymentId"] =  nsmutableMeatdata["paymentId"]
                        
                        nsmutableMeatdata["hiddenStatus"] = "false"
                        nsmutableMeatdata["paymentStatus"] = "paymentRejected"
                        nsmutableMeatdata["richMessageType"] = "paymentMessage"
                        nsmutableMeatdata["paymentReceiver"] = dbMessage?.to;
                        
                        message.metadata = nsmutableMeatdata
                        
                        ALMessageService.sendMessages(message, withCompletion: {
                            message, error in
                            
                            if(message != nil){
                            }
                            self.delegate?.messageUpdated()
                            
                        })
                        
                    }
                    
                }
            })
            
        }
    }
    
    override func setupStyle() {
        super.setupStyle()
        
        timeLabel.setStyle(style: ALKMessageStyle.time)
    }
    
    override func setupViews() {
        super.setupViews()
        
        paymentRejectButton.isHidden = true;
        paymentAceptButton.isHidden = true;
        
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        paymentAceptButton.isUserInteractionEnabled = true
        paymentAceptButton.addTarget(self, action: #selector(actionAccept), for: .touchUpInside)
        
        paymentTitle.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleClick))
        paymentTitle.addGestureRecognizer(tapGesture)
        
        paymentRejectButton.addTarget(self, action: #selector(actionReject), for: .touchUpInside)
        paymentRejectButton.isUserInteractionEnabled = true
        
        
        contentView.addViewsForAutolayout(views: [avatarImageView,nameLabel,bubbleView,timeLabel])
        bubbleView.addViewsForAutolayout(views: [paymentTitle,paymentMoney,paymentSubjctTitle,paymentSubjctText,paymentAceptButton, paymentRejectButton])
        bubbleView.bringSubview(toFront:paymentTitle)
        bubbleView.bringSubview(toFront:paymentMoney)
        bubbleView.bringSubview(toFront:paymentSubjctTitle)
        bubbleView.bringSubview(toFront:paymentSubjctText)
        bubbleView.bringSubview(toFront:paymentAceptButton)
        bubbleView.bringSubview(toFront:paymentRejectButton)
        contentView.bringSubview(toFront:nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -6).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 57).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -57).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bubbleView.topAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18).isActive = true
        avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9).isActive = true
        
        avatarImageView.trailingAnchor.constraint(equalTo: paymentTitle.leadingAnchor, constant: -18).isActive = true
        
        avatarImageView.heightAnchor.constraint(equalToConstant: 37).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        //bubbleView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        let width = UIScreen.main.bounds.width * 0.40
        bubbleView.widthAnchor.constraint(equalToConstant: width)
        bubbleView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant:10).isActive = true
        
        
        let image = UIImage.init(named: "chat_bubble_grey", in: Bundle.applozic, compatibleWith: nil)
        bubbleView.image = image?.imageFlippedForRightToLeftLayoutDirection()
        bubbleView.tintColor = UIColor(netHex: 0xF1F0F0)
        
        timeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 17).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        timeLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive  = true
        
        
        paymentTitle.topAnchor.constraint(equalTo: bubbleView.topAnchor,constant:10).isActive = true
        paymentTitle.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 50).isActive = true
        paymentTitle.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -50).isActive = true
        paymentTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentTitle.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        paymentMoney.topAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 1).isActive = true
        paymentMoney.leadingAnchor.constraint(equalTo: paymentTitle.leadingAnchor, constant: 50).isActive = true
        paymentMoney.trailingAnchor.constraint(equalTo: paymentTitle.trailingAnchor, constant: -50).isActive = true
        paymentMoney.bottomAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 30).isActive = true
        paymentMoney.heightAnchor.constraint(equalToConstant: 15).isActive = true
        paymentMoney.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, multiplier: 0.4).isActive = true
        
        
        paymentSubjctTitle.topAnchor.constraint(equalTo: paymentMoney.bottomAnchor, constant: 1).isActive = true
        paymentSubjctTitle.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 50).isActive = true
        paymentSubjctTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentSubjctTitle.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, multiplier: 0.3).isActive = true
        
        paymentSubjctText.topAnchor.constraint(equalTo: paymentMoney.bottomAnchor, constant: 1).isActive = true
        paymentSubjctText.leadingAnchor.constraint(equalTo: paymentSubjctTitle.trailingAnchor, constant: 0).isActive = true
        paymentSubjctText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentSubjctText.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        
        paymentAceptButton.topAnchor.constraint(equalTo: paymentSubjctTitle.bottomAnchor, constant: 1).isActive = true
        
        paymentAceptButton.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: bubbleView.frame.width*0.2).isActive = true
        
        paymentAceptButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentAceptButton.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, multiplier: 0.4).isActive = true
        
        
        paymentRejectButton.topAnchor.constraint(equalTo: paymentSubjctText.bottomAnchor, constant: 1).isActive = true
        paymentRejectButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentRejectButton.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, multiplier: 0.4).isActive = true
        paymentRejectButton.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -30).isActive = true
        
    }
    
    
    @objc private func uploadButtonAction(_ selector: UIButton) {
        uploadTapped?(true)
    }
    
    
    
    deinit {
        actionButton.removeTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    }
    
    
    
    func updateView(for state: state) {
        DispatchQueue.main.async {
            self.updateView(state: state)
        }
    }
    
    func titleClick(){
        
        if(viewModel?.channelKey != nil){
            
            let storyboard = UIStoryboard(name: "ALKPaymentUsers", bundle:Bundle.applozic )
            
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "PaymentUsers") as? ALKBaseNavigationViewController {
                
                guard let firstVC = vc.viewControllers.first else {return}
                
                var  viewController = firstVC as! ALPaymentUsersController
                
                
                var nsmutableMeatdata = Dictionary<String, Any>();
                nsmutableMeatdata =   (viewModel?.metadata)!
                
                let ns = nsmutableMeatdata["usersRequested"] as? String;
                if(ns != nil){
                    let string1 =   ns?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]",with: "").replacingOccurrences(of: "\"",with: "")
                    
                    
                    let arary : [String] = string1!.components(separatedBy: ",")
                    
                    
                    viewController.groupMembers = arary as! [String]
                    
                    
                    UIViewController.topViewController()?.present(vc, animated: true, completion: {
                        
                    })
                    
                }
            }
            
        }
        
    }
    
    private func updateView(state: state) {
        
    }
    
    func setImage(imageView: UIImageView, name: String) {
        DispatchQueue.global(qos: .background).async {
            let docDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let path = docDirPath.appendingPathComponent(name)
            do {
                let data = try Data(contentsOf: path)
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            } catch {
                DispatchQueue.main.async {
                    imageView.image = nil
                }
            }
        }
    }
    
    @objc private func acceptButtonButtonAction(_ selector: UIButton) {
        accpetButtonTapped?(true)
    }
    
    fileprivate func updateDbMessageWith(key: String, value: String, filePath: String) {
        let messageService = ALMessageDBService()
        let alHandler = ALDBHandler.sharedInstance()
        let dbMessage: DB_Message = messageService.getMessageByKey(key, value: value) as! DB_Message
        dbMessage.filePath = filePath
        do {
            try alHandler?.managedObjectContext.save()
        } catch {
            NSLog("Not saved due to error")
        }
    }
    
    
}
