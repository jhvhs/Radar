// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AppMenu: View {
    @EnvironmentObject var concourseData: ConcourseData
    @EnvironmentObject var tokenServer: HTTPTokenServer

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack {
            ConcourseMenu()
                .environmentObject(concourseData)
                .environmentObject(tokenServer)

            Button(NSLocalizedString("Preferences menu item caption", comment: "")) {
                openWindow(id: kPreferencesSceneID)
                NSApplication.shared.activate(ignoringOtherApps: true)
            }.keyboardShortcut(",")
            
            Divider()
            
            Button(NSLocalizedString("Quit menu item caption", comment: "")) {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("Q")
        }
    }

}
