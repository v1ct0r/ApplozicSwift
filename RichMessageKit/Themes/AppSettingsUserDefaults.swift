//
//  ALKThemeSettings.swift
//  ApplozicSwift
//
//  Created by Sunil on 29/04/20.
//

import Foundation

internal struct AppSettingsUserDefaults {
    enum SettingsKey {
        static let primaryColor = "primaryColor"
        static let secondaryColor = "secondaryColor"
        static let showPoweredBy = "showPoweredBy"
        static let sentMessageBackgroundColor = "sentMessageBackgroundColor"
    }

    var appSettings = "ALK_APP_SETTINGS"

    internal func setAppSettings(settingsDictionary: [String: Any]) {
        UserDefaults.standard.set(settingsDictionary, forKey: appSettings)
    }

    internal func updateOrSetAppSettings(settingsDictionary: [String: Any]) {
        var updatedSettingsDictionary = settingsDictionary

        let extstingAppSettings = getAppSettings()

        if extstingAppSettings == nil {
            setAppSettings(settingsDictionary: updatedSettingsDictionary)
        } else {
            // Keep the sent message background color
            if let settings = extstingAppSettings, settings.keys.contains(SettingsKey.sentMessageBackgroundColor), let existingSentMessageBackgroundColor = settings[SettingsKey.sentMessageBackgroundColor] {
                updatedSettingsDictionary[SettingsKey.sentMessageBackgroundColor] = existingSentMessageBackgroundColor
            }
            setAppSettings(settingsDictionary: updatedSettingsDictionary)
        }
    }

    internal func getAppSettings() -> [String: Any]? {
        return UserDefaults.standard.value(forKey: appSettings) as? [String: Any]
    }

    internal func clear() {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        let keyArray = dictionary.keys
        for key in keyArray {
            if key.hasPrefix("ALK") {
                UserDefaults.standard.removeObject(forKey: key)
                UserDefaults.standard.synchronize()
            }
        }
    }
}
