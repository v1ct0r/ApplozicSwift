//
//  QuickReplyStyle.swift
//  ApplozicSwift
//
//  Created by Sunil on 26/05/20.
//

import Foundation

/// `QuickReplyButtonStyle` struct is used for config the sent and received message button
public struct QuickReplyButtonStyle {
    public struct Color {
        /// Used for text color
        public var text = UIColor(red: 85, green: 83, blue: 183)

        /// Used for border color of view
        public var border = UIColor(red: 85, green: 83, blue: 183).cgColor

        /// Used for background color of view
        public var background = UIColor.clear

        /// Used for tint color of image
        public var tint = UIColor(red: 85, green: 83, blue: 183)
    }

    /// Font for text inside view.
    public var font = UIFont.systemFont(ofSize: 14)

    /// Corner radius of view.
    public var cornerRadius: CGFloat = 15

    /// Border width of view.
    public var borderWidth: CGFloat = 2

    /// Instance of `Color` type that can be used to change the colors used in view.
    public var color = Color()
}
/// `QuickReplyStyle`struct can be used for changing the style of quick reply buttons
public struct QuickReplyStyle {
    /// `QuickReplyButtonStyle` for sent message
    public static var sentMessage: QuickReplyButtonStyle = QuickReplyButtonStyle()

    /// `QuickReplyButtonStyle` for received message
    public static var receivedMessage: QuickReplyButtonStyle = QuickReplyButtonStyle()
}
