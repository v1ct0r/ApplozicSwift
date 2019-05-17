//
//  LinkUITextView.swift
//  ApplozicSwift
//
//  Created by apple on 17/05/19.
//

import Foundation
import UIKit


class ALKUITextView: UITextView{

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        guard let pos = closestPosition(to: point) else { return false }

        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: .layout(.left)) else { return false }

        let startIndex = offset(from: beginningOfDocument, to: range.start)

        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }

    open override var canBecomeFirstResponder: Bool{
        return true
    }

}
