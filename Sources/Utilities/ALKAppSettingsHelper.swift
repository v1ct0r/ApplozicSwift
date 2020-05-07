//
//  ALKAppThemeSettings.swift
//  ApplozicSwift
//
//  Created by Sunil on 29/04/20.
//

import Foundation

public struct ALKAppSettingsHelper {
    public init() {}

    let themeSettings = AppSettingsUserDefaults()

    let navigationBarProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [ALKBaseNavigationViewController.self])

    public func getAppPrimaryColor() -> UIColor {
        if let appDic = themeSettings.getAppSettings(), let primaryColor = appDic[AppSettingsUserDefaults.SettingsKey.primaryColor] as? String {
            return UIColor(hexString: primaryColor)
        }
        return UIColor.navigationOceanBlue()
    }

    public func getAppBarTintColor() -> UIColor {
        if let barTintColor = navigationBarProxy.barTintColor {
            return barTintColor
        }
        return getAppPrimaryColor()
    }

    public func getSentMessageBackgroundColor() -> UIColor {
        let sentMessageBubbleColor = ALKMessageStyle.sentBubble.color
        if let sentBubbleColor = sentMessageBubbleColor {
            return sentBubbleColor
        } else if let appDic = themeSettings.getAppSettings(), let sentMessageBackgroundColor = appDic[AppSettingsUserDefaults.SettingsKey.sentMessageBackgroundColor] as? String {
            return UIColor(hexString: sentMessageBackgroundColor)
        }

        return ALKMessageStyle.Bubble.DefaultColor.sentBubbleColor
    }

    public func getAttachmentIconsTintColor() -> UIColor {
        if let appDic = themeSettings.getAppSettings(), let primaryColor = appDic[AppSettingsUserDefaults.SettingsKey.primaryColor] as? String {
            return UIColor(hexString: primaryColor)
        }
        return UIColor.gray
    }

    public func updateSentMessageBackgroundColor(color: UIColor?) {
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
        settingsDictionary[AppSettingsUserDefaults.SettingsKey.sentMessageBackgroundColor] = UIColor.hexStringFromColor(color: sentMessageBackgroundColor)
        themeSettings.setAppSettings(settingsDictionary: settingsDictionary)
    }

    /// Will be used for updating or set the app settings
    public func updateOrSetAppSettings(settingsDictionary: [String: Any]) {
        themeSettings.updateOrSetAppSettings(settingsDictionary: settingsDictionary)
    }

    public func clearAppSettingsUserDefaults() {
        themeSettings.clear()
    }
}
