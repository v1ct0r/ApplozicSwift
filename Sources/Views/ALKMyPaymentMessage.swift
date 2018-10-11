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
    
    let YouRequestedFrom: String = {
        let text = NSLocalizedString("YouRequestedFrom", value: SystemMessage.PaymentMessage.YouRequestedFrom, comment: "")
        return text
    }()
    let YouRejected: String = {
        let text = NSLocalizedString("YouRejected", value: SystemMessage.PaymentMessage.YouRejected, comment: "")
        return text
    }()
    let S: String = {
        let text = NSLocalizedString("S", value: SystemMessage.PaymentMessage.S, comment: "")
        return text
    }()
    let Rejected: String = {
        let text = NSLocalizedString("Rejected", value: SystemMessage.PaymentMessage.Rejected, comment: "")
        return text
    }()
    let Payment: String = {
        let text = NSLocalizedString("Payment", value: SystemMessage.PaymentMessage.Payment, comment: "")
        return text
    }()
    let YouPaidTo: String = {
        let text = NSLocalizedString("YouPaidTo", value: SystemMessage.PaymentMessage.YouPaidTo, comment: "")
        return text
    }()
    let RequestedFromYou: String = {
        let text = NSLocalizedString("RequestedFromYou", value: SystemMessage.PaymentMessage.RequestedFromYou, comment: "")
        return text
    }()
    let YouAccepted: String = {
        let text = NSLocalizedString("YouAccepted", value: SystemMessage.PaymentMessage.YouAccepted, comment: "")
        return text
    }()
    let PaidYou: String = {
        let text = NSLocalizedString("PaidYou", value: SystemMessage.PaymentMessage.PaidYou, comment: "")
        return text
    }()
    let Asunto: String = {
        let text = NSLocalizedString("Asunto", value: SystemMessage.PaymentMessage.Asunto, comment: "")
        return text
    }()
    let Re: String = {
        let text = NSLocalizedString("Re", value: SystemMessage.PaymentMessage.Re, comment: "")
        return text
    }()
    
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
        let image = UIImage.init(named: "chat_bubble_rounded", in: Bundle.applozic, compatibleWith: nil)
        bv.tintColor = UIColor(netHex: 0xF1F0F0)
        bv.image = image?.imageFlippedForRightToLeftLayoutDirection()
        bv.isOpaque = true
        bv.isUserInteractionEnabled = true
        bv.setImageColor(color: UIColor(netHex: 0xF1F0F0))
        return bv
    }()
    
    
    var paymentTitle: PaddingLabel = {
        let lb = PaddingLabel(withInsets: 0, 0, 5, 5)
        lb.textAlignment = .center
        lb.textColor=UIColor.white
        lb.font = Font.bold(size: 15.0).font()
        lb.numberOfLines = 0
        return lb
    }()
    
    
    var paymentMoney: UILabel = {
        let lb = UILabel()
        lb.font = Font.bold(size: 15.0).font()
        lb.textAlignment = .center
        lb.backgroundColor=UIColor.clear
        return lb
    }()
    
    
    var paymentSubjctTitle: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.backgroundColor = UIColor.clear
        lb.font = Font.bold(size: 14.0).font()
        return lb
    }()
    
    var paymentSubjctText: UILabel = {
        let lb = UILabel()
        lb.font = Font.normal(size: 14.0).font()
        lb.backgroundColor=UIColor.clear
        lb.textColor = UIColor.black
        lb.numberOfLines = 0
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
        
        var heigh = (width*0.27)
        
        //calculate height from viewModel:
        if let dict = viewModel.metadata, let paymentText = dict["paymentSubject"] as? String {
            var size = CGRect()
            //calclate exact width
            let widthNoPadding = (width * 0.4)
            
            let maxSize = CGSize.init(width: widthNoPadding, height: CGFloat.greatestFiniteMagnitude)
            let font = Font.normal(size: 14).font()
            let color = UIColor.color(ALKMessageStyle.message.color)
            
            let style = NSMutableParagraphStyle.init()
            style.lineBreakMode = .byWordWrapping
            style.headIndent = 0
            style.tailIndent = 0
            style.firstLineHeadIndent = 0
            style.minimumLineHeight = 17
            style.maximumLineHeight = 17
            
            let attributes: [String : Any] = [NSFontAttributeName: font,
                                              NSForegroundColorAttributeName: color,
                                              NSParagraphStyleAttributeName: style]
            size = paymentText.boundingRect(with: maxSize, options: [NSStringDrawingOptions.usesFontLeading, NSStringDrawingOptions.usesLineFragmentOrigin],attributes: attributes, context: nil)
            let height = ceil(size.height)
            if height > 20.0 {
                heigh += height
            }
        }
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
    
    func addPoints(inputNumber: String) -> String{
        var number = NSMutableString(string: inputNumber)
        var count: Int = number.length
        while count >= 4 {
            count = count - 3
            number.insert(".", at: count) // you also can use ","
        }
        return number as String
    }
    
    override func update(viewModel: ALKMessageViewModel) {
        
        self.viewModel = viewModel
        activityIndicator.color = .black
        var nsmutable =  viewModel.metadata
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
            var amountString = "\(doller) \(amount as! String)"
            
            if let amountAsString = amount as? String, let amountAsInt = Int(amountAsString) {
//                let formatter = NumberFormatter()
//                formatter.groupingSeparator = "."
//                formatter.numberStyle = .decimal
//                if let amnt = formatter.string(for: amountAsInt) {
//                    amountString = "\(doller) \(amnt)"
//                }
                amountString = "\(doller) \(addPoints(inputNumber: amountAsString))"
            }
            
            if(viewModel.isMyMessage){
                if(paymentStatus != nil && "paymentRequested"  ==  paymentStatus as! String!){
                    paymentMoney.text = amountString
                    if(viewModel.channelKey != nil){
                        
                        let  channelService = ALChannelDBService();
                        let  messageDb = ALMessageDBService();
                        let requestedString = YouRequestedFrom
                        if(nsmutable!["paymentHeader"] == nil){
                            let groupNames = channelService.string(fromChannelUserMetaData: NSMutableDictionary(dictionary: nsmutable!), paymentMessageTitle: true)
                            
                            nsmutable!["paymentHeader"] = groupNames
                            paymentTitle.text = requestedString + groupNames!
                            let channeldb = messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable!))
                            
                        }else{
                            paymentTitle.text = requestedString + (nsmutable!["paymentHeader"] as? String)!
                        }
                    }else if(viewModel.contactId != nil){
                        paymentTitle.text = YouRequestedFrom + viewModel.displayName!
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
                                    let groupNames = YouRejected + (contact?.getDisplayName())! + S + Payment
                                    
                                    nsmutable!["paymentHeader"] = groupNames
                                    paymentTitle.text = groupNames
                                    
                                    let channeldb = messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable!))
                                }
                            }
                        }else{
                            paymentTitle.text =  (nsmutable!["paymentHeader"] as? String)!
                        }
                    }else{
                        paymentTitle.text = viewModel.displayName!+Rejected
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
                                    let groupNames = YouPaidTo + (contact?.getDisplayName())!
                                    nsmutable!["paymentHeader"] = groupNames
                                    paymentTitle.text = groupNames
                                    let channeldb = messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable! ))
                                }
                            }else{
                                paymentTitle.text =  (nsmutable!["paymentHeader"] as? String)!
                            }
                        }else{
                            paymentTitle.text = YouPaidTo+viewModel.displayName!
                        }
                    }else{
                        if(viewModel.channelKey != nil){
                            let  channelService = ALChannelDBService();
                            let  messageDb = ALMessageDBService();
                            let payedString = YouPaidTo
                            if(nsmutable!["paymentHeader"] == nil){
                                let groupNames = channelService.string(fromChannelUserMetaData:NSMutableDictionary(dictionary: nsmutable!) , paymentMessageTitle: true)
                                nsmutable!["paymentHeader"] = groupNames
                                paymentTitle.text = payedString + groupNames!
                                
                                let channeldb = messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable!))
                                
                            }else{
                                paymentTitle.text = payedString + (nsmutable!["paymentHeader"] as? String)!
                            }
                        }else{
                            paymentTitle.text = YouPaidTo+viewModel.displayName!
                            
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
                            
                            messageDb.updateMessageMetaData(viewModel.identifier, withMetadata:NSMutableDictionary(dictionary: nsmutable!))
                            
                        }else{
                            
                            paymentTitle.text =  nsmutable!["paymentHeader"] as? String
                            
                        }
                        
                    }else if(viewModel.contactId != nil){
                        paymentTitle.text = viewModel.displayName! + RequestedFromYou
                        
                    }
                    
                    paymentMoney.text = amountString
                    
                    
                }else if("paymentRejected" == paymentStatus as! String!){
                    
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:  amountString)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                    
                    paymentTitle.text = YouRejected
                    
                    paymentMoney.attributedText = attributeString
                    
                    
                }else if("paymentAccepted" == paymentStatus as! String!){
                    paymentMoney.text = amountString
                    paymentTitle.text = YouAccepted
                }else{
                    paymentMoney.text = amountString
                    paymentTitle.text = viewModel.displayName! + PaidYou
                }
            }
            
            paymentSubjctTitle.text = Asunto
            paymentSubjctText.text = paymentSubject as? String
            
            setUpPaymentMessageColor(paymentStatus: paymentStatus as! String)
        }
        
        timeLabel.text   = viewModel.time
        
    }
    
    private func setUpPaymentMessageColor(paymentStatus: String){
        var paymentColor = ALKConfiguration.init().customPrimary;//default
        switch (paymentStatus){
            case "paymentSent":
                paymentColor = ALKConfiguration.init().paymentSent
            case "paymentAccepted":
                paymentColor = ALKConfiguration.init().paymentSent
            case "paymentRequested":
                paymentColor = ALKConfiguration.init().paymentRequested
            case "paymentRejected":
                paymentSubjctTitle.text = Re
                paymentColor = ALKConfiguration.init().paymentRequested
            default:
                print("This should never occur");
        }
        paymentTitle.textColor = UIColor.white
        paymentTitle.backgroundColor = paymentColor
        paymentMoney.textColor = paymentColor
        paymentSubjctTitle.textColor = paymentColor
        bubbleView.layer.borderColor = paymentColor.cgColor
        bubbleView.layer.cornerRadius = 12
        bubbleView.clipsToBounds = true
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
        
        contentView.sizeToFit()
        
        paymentTitle.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleClick))
        paymentTitle.addGestureRecognizer(tapGesture)
        
        bubbleView.addViewsForAutolayout(views: [paymentTitle,paymentMoney,paymentSubjctTitle,paymentSubjctText])
        bubbleView.bringSubview(toFront:paymentTitle)
        bubbleView.bringSubview(toFront:paymentMoney)
        bubbleView.bringSubview(toFront:paymentSubjctTitle)
        bubbleView.bringSubview(toFront:paymentSubjctText)
        
        bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        let width = UIScreen.main.bounds.width * 0.40
        bubbleView.widthAnchor.constraint(equalToConstant: width)
        bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:100).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-10).isActive = true
        
        bubbleView.layer.borderColor = UIColor(netHex: 0xFBB040).cgColor
        bubbleView.layer.borderWidth = 2
        bubbleView.layer.cornerRadius = 5
        bubbleView.clipsToBounds = true
        
        paymentTitle.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        paymentTitle.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor).isActive = true
        paymentTitle.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
//        paymentTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        paymentMoney.topAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 1).isActive = true
        paymentMoney.leadingAnchor.constraint(equalTo: paymentTitle.leadingAnchor).isActive = true
        paymentMoney.trailingAnchor.constraint(equalTo: paymentTitle.trailingAnchor).isActive = true
        paymentMoney.bottomAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 30).isActive = true
        paymentMoney.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        paymentSubjctTitle.topAnchor.constraint(equalTo: paymentMoney.bottomAnchor, constant: 1).isActive = true
        paymentSubjctTitle.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10).isActive = true
        paymentSubjctTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        paymentSubjctText.topAnchor.constraint(equalTo: paymentMoney.bottomAnchor, constant: 2).isActive = true
        paymentSubjctText.leadingAnchor.constraint(equalTo: paymentSubjctTitle.trailingAnchor, constant: 10).isActive = true
        paymentSubjctText.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5).isActive = true
        
        stateView.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        stateView.heightAnchor.constraint(equalToConstant: 9.0).isActive = true
        stateView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -1.0).isActive = true
        stateView.trailingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -2.0).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: -2.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2).isActive = true
        
        bubbleView.sizeToFit()
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

