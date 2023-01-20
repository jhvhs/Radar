// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct RadarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var concourseData = ConcourseData().startTimer()
    @StateObject private var tokenServer = HTTPTokenServer().setupListenAndWait()
    @AppStorage(kShowPreferencesWindow) var showPreferencesWindow: Bool = false 
    
    var body: some Scene {
        Window(NSLocalizedString("Preferences window title", comment: ""), id: kPreferencesSceneID) {
            PreferencesView()
        }
        .defaultSize(width: 400, height: 200)
        

        MenuBarExtra(NSLocalizedString("Menu label", comment: ""), systemImage: $concourseData.team.wrappedValue.statusIcon.rawValue) {
            AppMenu()
                .environmentObject(concourseData)
                .environmentObject(tokenServer)
        }
    }
}
