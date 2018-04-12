//
//  ALKBaseViewController.swift
//  ApplozicSwift
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import UIKit

open class ALKBaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NSLog("🐸 \(#function) 🍀🍀 \(self) 🐥🐥🐥🐥")
        self.addObserver()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 92.0 / 255.0, green: 90.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        
        self.navigationController?.navigationBar.tintColor =    UIColor(red: 255.0 / 255.0, green:255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)

        self.navigationController?.navigationBar.isTranslucent = false
        if self.navigationController?.viewControllers.first != self {
            var backImage = UIImage.init(named: "icon_back", in: Bundle.applozic, compatibleWith: nil)
            backImage = backImage?.imageFlippedForRightToLeftLayoutDirection()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: backImage, style: .plain, target: self , action: #selector(backTapped))
        }
    }
    
    @objc func backTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSLog("🐸 \(#function) 🍀🍀 \(self) 🐥🐥🐥🐥")
        self.addObserver()
    }
    
    func addObserver() {
        
    }
    
    func removeObserver() {
        
    }
    
    deinit {
        
        removeObserver()
        NSLog("💩 \(#function) ❌❌ \(self)‼️‼️‼️‼️")
    }
    
}
