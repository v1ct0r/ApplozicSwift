//
//  UIStackView+Extension.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 13/09/18.
//

import Foundation
import UIKit

extension UIStackView {
    
    public func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
}
