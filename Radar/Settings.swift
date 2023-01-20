// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Settings {
    static var concourseUrl: String {
        get { getSetting(kConcourseURL) }
        set { updateSetting(kConcourseURL, value: newValue) }
    }

    static var teamName: String {
        get { getSetting(kTeamName) }
        set { updateSetting(kTeamName, value: newValue) }
    }

    static var bearerToken: String {
        get { getSetting(kBearerToken) }
        set { updateSetting(kBearerToken, value: newValue) }
    }

    private static var userDefaults: UserDefaults {
        UserDefaults.standard
    }

    private static func getSetting(_ name: String) -> String {
        if let value = userDefaults.string(forKey: name) {
            return value
        }
        return ""
    }

    private static func updateSetting(_ name: String, value: String) {
        let d = userDefaults
        d.set(value, forKey: name)
        d.synchronize()
    }
}
