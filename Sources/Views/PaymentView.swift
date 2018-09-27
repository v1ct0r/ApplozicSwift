//
//  PaymentView.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 17/09/18.
//

import Foundation

public protocol PaymentViewProtocol: class {
    func paymentButtonClicked(paymentType: String)
}

open class PaymentView: UIView {
    
    private var delegate: PaymentViewProtocol!
    
    let sendPaymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.setTitle("Enviar", for: .normal)
        button.backgroundColor = ALKConfiguration.init().customPrimary
        button.setTitleColor(ALKConfiguration.init().customPrimaryDark, for: .normal)
        return button
    }()
    
    let requestPaymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.setTitle("Solicitar", for: .normal)
        button.backgroundColor = ALKConfiguration.init().paymentRequested
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    lazy var paymentButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.requestPaymentButton, self.sendPaymentButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(frame: CGRect, delegate: PaymentViewProtocol){
        super.init(frame: frame)
        self.delegate = delegate
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        layer.cornerRadius = 12
        
        addViewsForAutolayout(views: [paymentButtons])
        bringSubview(toFront: paymentButtons)
        
        paymentButtons.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        paymentButtons.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        paymentButtons.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        paymentButtons.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        sendPaymentButton.addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
        requestPaymentButton.addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
    }
    
    func tapped(button: UIButton){
        switch(button) {
            case sendPaymentButton:
                print("Send payment button tapped")
                delegate.paymentButtonClicked(paymentType: "paymentSent")
            
            case requestPaymentButton:
                print("Request payment button tapped")
                delegate.paymentButtonClicked(paymentType: "paymentRequested")
            
            default:
                print("This would never occur")
            
        }
    }
}
