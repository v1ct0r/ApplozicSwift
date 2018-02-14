//
//  ALKMyPaymentMessage.swift
//  ApplozicSwift
//
//  Created by Sunil on 15/01/18.
//

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

// MARK: - ALKPaymentCell
class ALKMyPaymentMessage: ALKChatBaseCell<ALKMessageViewModel> {
    
    
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
        bv.image = image?.imageFlippedForRightToLeftLayoutDirection()
        bv.isOpaque = true
        bv.isUserInteractionEnabled = true
        return bv
    }()
    
    
    
    
    
    var paymentTitle: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor=UIColor.black
        lb.font = Font.bold(size: 12.0).font()
        return lb
    }()
    
    
    var paymentMoney: UILabel = {
        let lb = UILabel()
        lb.font = Font.bold(size: 14.0).font()
        
        lb.textAlignment = .center
        
        lb.backgroundColor=UIColor.clear
        
        return lb
    }()
    
    
    var paymentSubjctTitle: UILabel = {
        let lb = UILabel()
        lb.backgroundColor=UIColor.clear
        lb.font = Font.bold(size: 14.0).font()
        return lb
    }()
    
    var paymentSubjctText: UILabel = {
        let lb = UILabel()
        lb.font = Font.bold(size: 14.0).font()
        lb.textAlignment = .left
        
        lb.backgroundColor=UIColor.clear
        return lb
    }()
    
    
    fileprivate let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var uploadTapped:((Bool) ->())?
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
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = Font.bold(size: 14.0).font()
        label.textColor = .text(.black00)
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
        
        var nsmutable =  viewModel.metaData
        
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
                    
                    paymentMoney.text = amountString
                    if(viewModel.channelKey != nil){
                        
                        let  channelService = ALChannelDBService();
                        let  messageDb = ALMessageDBService();
                        let requestedString = "You requested from "
                        if(nsmutable!["paymentHeader"] == nil){
                            
                            
                            let groupNames = channelService.string(fromChannelUserMetaData:viewModel.metaData , paymentMessageTitle: true)
                            
                            nsmutable!["paymentHeader"] = groupNames
                            paymentTitle.text = requestedString + groupNames!
                            
                            let channeldb = messageDb.updateMessageMetaData(viewModel.messageKey, withMetadata:nsmutable )
                            
                        }else{
                            paymentTitle.text = requestedString + (nsmutable!["paymentHeader"] as? String)!
                        }
                        
                        
                        
                    }else if(viewModel.contactId != nil){
                        paymentTitle.text = viewModel.displayName! + " requested from you "
                        
                    }
                    
                    
                }else if("paymentRejected" == paymentStatus as! String!){
                    
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:                  amountString)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
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
                                    let groupNames = "You rejected " + (contact?.getDisplayName())! + "'s" + " payment"
                                    
                                    nsmutable!["paymentHeader"] = groupNames
                                    paymentTitle.text = groupNames
                                    
                                    let channeldb = messageDb.updateMessageMetaData(viewModel.messageKey, withMetadata:nsmutable )
                                }
                                
                            }
                        }else{
                            paymentTitle.text =  (nsmutable!["paymentHeader"] as? String)!
                        }
                        
                        
                    }else{
                        paymentTitle.text = viewModel.displayName!+" rejected"
                    }
                    
                    
                }else{
                    
                    paymentMoney.text = amountString
                    
                    let paymentReceiver =   nsmutable!["paymentReceiver"] as? String
                    
                    if(paymentReceiver != nil){
                        if(viewModel.channelKey != nil){
                            
                            let  channelService = ALChannelDBService();
                            let  messageDb = ALMessageDBService();
                            if(nsmutable!["paymentHeader"] == nil){
                                
                                let contactDataBase = ALContactDBService()
                                
                                let contact =  contactDataBase.loadContact(byKey: "userId", value: paymentReceiver);
                                if(contact != nil){
                                    let groupNames = "You paid to " + (contact?.getDisplayName())!
                                    
                                    nsmutable!["paymentHeader"] = groupNames
                                    paymentTitle.text = groupNames
                                    
                                    let channeldb = messageDb.updateMessageMetaData(viewModel.messageKey, withMetadata:nsmutable )
                                }
                                
                            }else{
                                
                                paymentTitle.text =  (nsmutable!["paymentHeader"] as? String)!
                            }
                            
                            
                        }else{
                            paymentTitle.text = "You paid to "+viewModel.displayName!
                        }
                        
                    }else{
                        
                        if(viewModel.channelKey != nil){
                            
                            
                            let  channelService = ALChannelDBService();
                            let  messageDb = ALMessageDBService();
                            let payedString = "You paid to "
                            if(nsmutable!["paymentHeader"] == nil){
                                
                                
                                let groupNames = channelService.string(fromChannelUserMetaData:viewModel.metaData , paymentMessageTitle: true)
                                nsmutable!["paymentHeader"] = groupNames
                                paymentTitle.text = payedString + groupNames!
                                
                                let channeldb = messageDb.updateMessageMetaData(viewModel.messageKey, withMetadata:nsmutable )
                                
                            }else{
                                paymentTitle.text = payedString + (nsmutable!["paymentHeader"] as? String)!
                            }
                            
                            
                        }else{
                            paymentTitle.text = "You paid to "+viewModel.displayName!
                            
                        }
                    }
                    
                    
                    
                }
                
            }
            else{
                if("paymentRequested"  ==  paymentStatus as! String!){
                    
                    if(viewModel.channelKey != nil){
                        let  channelService = ALChannelDBService();
                        let  messageDb = ALMessageDBService();
                        
                        if(nsmutable!["paymentHeader"] == nil){
                            let groupName = channelService.string(fromChannelUserList: viewModel.channelKey, paymentMessageTitle:false)
                            nsmutable!["paymentHeader"] = groupName
                            paymentTitle.text = groupName
                            
                            nsmutable!["paymentHeader"] = groupName
                            paymentTitle.text = groupName
                            
                            messageDb.updateMessageMetaData(viewModel.messageKey, withMetadata:nsmutable )
                            
                        }else{
                            
                            paymentTitle.text =  nsmutable!["paymentHeader"] as? String
                            
                        }
                        
                    }else if(viewModel.contactId != nil){
                        paymentTitle.text = viewModel.displayName! + " requested from you "
                        
                    }
                    
                    paymentMoney.text = amountString
                    
                    
                }else if("paymentRejected" == paymentStatus as! String!){
                    
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:  amountString)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                    
                    paymentTitle.text = "You rejected"
                    
                    paymentMoney.attributedText = attributeString
                    
                    
                }else if("paymentAccepted" == paymentStatus as! String!){
                    paymentMoney.text = amountString
                    paymentTitle.text = "You accpted"
                    
                }else{
                    paymentMoney.text = amountString
                    paymentTitle.text = viewModel.displayName! + " paid you"
                }
            }
            
            paymentSubjctTitle.text = "Asunto:"
            paymentSubjctText.text = paymentSubject as? String
        }
        
        timeLabel.text   = viewModel.time
        
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
    
    fileprivate var stateView: UIImageView = {
        let sv = UIImageView()
        sv.isUserInteractionEnabled = false
        sv.contentMode = .center
        return sv
    }()
    
    
    override func setupStyle() {
        super.setupStyle()
        
        timeLabel.setStyle(style: ALKMessageStyle.time)
    }
    
    override func setupViews() {
        super.setupViews()
        
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        
        contentView.addViewsForAutolayout(views: [stateView,timeLabel,bubbleView])
        
        paymentTitle.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleClick))
        paymentTitle.addGestureRecognizer(tapGesture)
        
        
        bubbleView.addViewsForAutolayout(views: [paymentTitle,paymentMoney,paymentSubjctTitle,paymentSubjctText])
        bubbleView.bringSubview(toFront:paymentTitle)
        bubbleView.bringSubview(toFront:paymentMoney)
        bubbleView.bringSubview(toFront:paymentSubjctTitle)
        bubbleView.bringSubview(toFront:paymentSubjctText)
        
        bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        let width = UIScreen.main.bounds.width * 0.40
        bubbleView.widthAnchor.constraint(equalToConstant: width)
        bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:100).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-10).isActive = true
        
        
        paymentTitle.topAnchor.constraint(equalTo: bubbleView.topAnchor,constant:10).isActive = true
        paymentTitle.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 40).isActive = true
        paymentTitle.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -40).isActive = true
        paymentTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentTitle.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        paymentMoney.topAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 1).isActive = true
        paymentMoney.leadingAnchor.constraint(equalTo: paymentTitle.leadingAnchor, constant: 50).isActive = true
        paymentMoney.trailingAnchor.constraint(equalTo: paymentTitle.trailingAnchor, constant: -50).isActive = true
        paymentMoney.bottomAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 30).isActive = true
        paymentMoney.heightAnchor.constraint(equalToConstant: 15).isActive = true
        paymentMoney.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, multiplier: 0.4).isActive = true
        
        
        paymentSubjctTitle.topAnchor.constraint(equalTo: paymentMoney.bottomAnchor, constant: 1).isActive = true
        paymentSubjctTitle.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 70).isActive = true
        paymentSubjctTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentSubjctTitle.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, multiplier: 0.3).isActive = true
        
        paymentSubjctText.topAnchor.constraint(equalTo: paymentMoney.bottomAnchor, constant: 1).isActive = true
        paymentSubjctText.leadingAnchor.constraint(equalTo: paymentSubjctTitle.trailingAnchor, constant: -20).isActive = true
        paymentSubjctText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentSubjctText.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        
        stateView.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        stateView.heightAnchor.constraint(equalToConstant: 9.0).isActive = true
        stateView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -1.0).isActive = true
        stateView.trailingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -2.0).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: -2.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2).isActive = true
        
        
    }
    
    deinit {
        actionButton.removeTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    }
    
    @objc private func downloadButtonAction(_ selector: UIButton) {
        downloadTapped?(true)
        
    }
    
    
    func updateView(for state: state) {
        DispatchQueue.main.async {
            self.updateView(state: state)
        }
    }
    
    private func updateView(state: state) {
        
    }
    
    func titleClick(){
        
        let storyboard = UIStoryboard(name: "ALKPaymentUsers", bundle:Bundle.applozic )
        
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "PaymentUsers") as? ALKBaseNavigationViewController {
            
            guard let firstVC = vc.viewControllers.first else {return}
            
            var  viewController = firstVC as! ALPaymentUsersController
            
            var nsmutableMeatdata = NSMutableDictionary();
            nsmutableMeatdata =   (viewModel?.metaData)!
            
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
    
    @objc private func uploadButtonAction(_ selector: UIButton) {
        uploadTapped?(true)
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

