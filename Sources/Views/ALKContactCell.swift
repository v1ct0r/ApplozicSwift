//
//  ALKContactCell.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 14/09/18.
//

import Foundation
import Applozic
import Kingfisher

class ALKContactCell: UITableViewCell{
   
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
        
        contentView.addViewsForAutolayout(views: [imgDisplay, lblDisplayName, separatorView])
        
        // Image Display
        imgDisplay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11).isActive = true
        imgDisplay.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        imgDisplay.heightAnchor.constraint(equalToConstant: 33).isActive = true
        imgDisplay.widthAnchor.constraint(equalTo: imgDisplay.heightAnchor).isActive = true
        imgDisplay.trailingAnchor.constraint(equalTo: lblDisplayName.leadingAnchor, constant: -15).isActive = true
        
        // Label
        lblDisplayName.centerYAnchor.constraint(equalTo: imgDisplay.centerYAnchor, constant: 2).isActive = true
        lblDisplayName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
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
}
