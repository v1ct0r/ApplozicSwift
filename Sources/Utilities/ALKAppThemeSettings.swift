//
//  ALKAppThemeSettings.swift
//  ApplozicSwift
//
//  Created by Sunil on 29/04/20.
//

import Foundation

public struct ALKAppThemeSettings {
    public init() {}

    let themeSettings = ThemeSettings()

    let navigationBarProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [ALKBaseNavigationViewController.self])

    func getAppPrimaryColor() -> UIColor {
        if let barTintColor = navigationBarProxy.barTintColor {
            return barTintColor
        } else if let appDic = themeSettings.getAppSettings(), let primaryColor = appDic[ThemeSettings.SettingsKey.primaryColor] as? String {
            return UIColor(hexString: primaryColor)
        }
        return UIColor.navigationOceanBlue()
    }

    func getSentMessageBackgroundColor() -> UIColor {
        let sentMessageBubbleColor = ALKMessageStyle.sentBubble.color
        if let sentBubbleColor = sentMessageBubbleColor {
            return sentBubbleColor
        } else if let appDic = themeSettings.getAppSettings(), let sentMessageBackgroundColor = appDic[ThemeSettings.SettingsKey.sentMessageBackgroundColor] as? String {
            return UIColor(hexString: sentMessageBackgroundColor)
        }

        return ALKMessageStyle.Bubble.DefaultColor.sentBubbleColor
    }

    func getAttachmentIconsTintColor() -> UIColor {
        if let appDic = themeSettings.getAppSettings(), let primaryColor = appDic[ThemeSettings.SettingsKey.primaryColor] as? String {
            return UIColor(hexString: primaryColor)
        }
        return UIColor.gray
    }

    func updateSentMessageBackgroundColor(color: UIColor?) {
        guard let sentMessageBackgroundColor = color else {
            return
        }
        var appSettingsDictionary = themeSettings.getAppSettings()

        if appSettingsDictionary == nil {
            appSettingsDictionary = [String: Any]()
        }
        guard var settingsDictionary = appSettingsDictionary else {
            return
        }
        settingsDictionary[ThemeSettings.SettingsKey.sentMessageBackgroundColor] = UIColor.hexStringFromColor(color: sentMessageBackgroundColor)
        themeSettings.setAppSettings(settingsDictionary: settingsDictionary)
    }
}
