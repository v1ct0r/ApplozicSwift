//
//  GroupPaymentPopupCell.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 18/09/18.
//

import Foundation
import Applozic
import Kingfisher

class GroupPaymentPopupCell: UITableViewCell {
    
    private var imgDisplay: UIImageView = {
        let imv             = UIImageView()
        imv.contentMode     = .scaleAspectFill
        imv.clipsToBounds   = true
        let layer           = imv.layer
        layer.cornerRadius  = 16.5
        layer.backgroundColor = UIColor.clear.cgColor
        layer.masksToBounds = true
        return imv
    }()
    
    private var lblDisplayName: UILabel = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.font          = UIFont.systemFont(ofSize: 17)
        label.textColor     = .text(.black00)
        return label
    }()
    
    private var checkBox: UIView = {
        let view                = UIView()
        view.layer.borderColor  = UIColor.darkGray.cgColor
        view.layer.cornerRadius = 5
        view.layer.borderWidth  = 2
        return view
    }()
    
    private var separatorView: UIView = {
        let view             = UIView()
        view.backgroundColor = .color(Color.Background.grayF1)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(){
        
        contentView.addViewsForAutolayout(views: [imgDisplay, lblDisplayName, checkBox, separatorView])
        
        // Image Display
        imgDisplay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11).isActive = true
        imgDisplay.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        imgDisplay.heightAnchor.constraint(equalToConstant: 33).isActive = true
        imgDisplay.widthAnchor.constraint(equalTo: imgDisplay.heightAnchor).isActive = true
        imgDisplay.trailingAnchor.constraint(equalTo: lblDisplayName.leadingAnchor, constant: -15).isActive = true
        
        // Label
        lblDisplayName.centerYAnchor.constraint(equalTo: imgDisplay.centerYAnchor, constant: 2).isActive = true
        lblDisplayName.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -10).isActive = true
        
        //checkbox
        checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: imgDisplay.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        // Separator
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func update(contact: ALContact){
        lblDisplayName.text = contact.getDisplayName()
        //image
        let placeHolder = UIImage(named: "placeholder", in: Bundle.applozic, compatibleWith: nil)
        if contact.contactImageUrl != nil{
            let imageURL = URL(string: contact.contactImageUrl)
            let resource = ImageResource(downloadURL: imageURL!)
            imgDisplay.kf.setImage(with: resource, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            imgDisplay.image = placeHolder
        }
    }
    
    func selectCheckBox() {
        //checkMark Image
        checkBox.backgroundColor = ALKConfiguration.init().customPrimary
    }
    
    func deselectCheckBox() {
        checkBox.backgroundColor = UIColor.clear
    }
}

protocol GroupPaymentPopupHeaderProtocol: class {
    func selectAll()
    func deselectAll()
}

class GroupPaymentPopupHeader: UITableViewHeaderFooterView {
    
    fileprivate var delegate: GroupPaymentPopupHeaderProtocol!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var selectAllLabel: UILabel = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.font          = UIFont.systemFont(ofSize: 17)
        label.textColor     = ALKConfiguration.init().customPrimaryDark
        label.text          = "Todos"
        return label
    }()
    
    fileprivate var checkBox: UIButton = {
        let button                = UIButton(type: .custom)
        button.layer.borderColor  = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth  = 2
        button.tag = 0
        return button
    }()
    
    func setDelegate(delegate: GroupPaymentPopupHeaderProtocol) {
        self.delegate = delegate
    }
    
    func setupViews() {
        addViewsForAutolayout(views: [selectAllLabel, checkBox])
        // Label
        selectAllLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 2).isActive = true
        selectAllLabel.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -10).isActive = true
        
        //checkbox
        checkBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        checkBox.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }
    
    func toggleSelection() {
        if checkBox.tag == 0{
            self.delegate.selectAll()
            selectCheckBox()
        } else {
            self.delegate.deselectAll()
            deselectCheckBox()
        }
    }
    
    func selectCheckBox() {
        checkBox.tag = 1
        checkBox.setImage(UIImage(named: "checkMark.png"), for: .normal)
        checkBox.backgroundColor = ALKConfiguration.init().customPrimary
    }
    
    func deselectCheckBox() {
        checkBox.tag = 0
        checkBox.backgroundColor = UIColor.clear
    }
}
