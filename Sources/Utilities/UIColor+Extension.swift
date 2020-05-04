//
//  UIColor+Extension.swift
//  ApplozicSwift
//
//  Created by Mukesh Thawani on 04/05/17.
//  Copyright © 2017 Applozic. All rights reserved.
//

import Foundation

import UIKit

public extension UIColor {
    // 0xAARRGGBB
    static func hex8(_ netHex: Int64) -> UIColor {
        let shiftedRed = netHex >> 16
        let redBits = shiftedRed & 0xFF

        let shiftedGreen = netHex >> 8
        let greenBits = shiftedGreen & 0xFF

        let shiftedBlue = netHex
        let blueBits = shiftedBlue & 0xFF

        let alpha = CGFloat((netHex >> 24) & 0xFF)
        return UIColor(red: Int(redBits), green: Int(greenBits), blue: Int(blueBits)).withAlphaComponent(alpha / 255.0)
    }

    static func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = ((components?.count ?? 0) > 2 ? components?[2] : g) ?? 0

        let hexString = String(format: "%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }

    static func mainRed() -> UIColor {
        return UIColor(netHex: 0xE00909)
    }

    static func borderGray() -> UIColor {
        return UIColor(netHex: 0xDBDFE2)
    }

    static func lineBreakerProfile() -> UIColor {
        return UIColor(netHex: 0xEAEAEA)
    }

    static func circleChartStartPointRed() -> UIColor {
        return UIColor(netHex: 0xCE0A11)
    }

    static func circleChartGray() -> UIColor {
        return UIColor(netHex: 0xCCCCCC)
    }

    static func circleChartPurple() -> UIColor {
        return UIColor(netHex: 0x350064)
    }

    static func circleChartTextColor() -> UIColor {
        return UIColor(netHex: 0x666666)
    }

    static func placeholderGray() -> UIColor {
        return UIColor(netHex: 0xCCCCCC)
    }

    static func disabledButton() -> UIColor {
        return UIColor(netHex: 0xCCCCCC)
    }

    static func onlineGreen() -> UIColor {
        return UIColor(netHex: 0x0EB04B)
    }

    static func navigationOceanBlue() -> UIColor {
        return UIColor(netHex: 0xECEFF1)
    }

    static func navigationTextOceanBlue() -> UIColor {
        return UIColor(netHex: 0x19A5E4)
    }
}
