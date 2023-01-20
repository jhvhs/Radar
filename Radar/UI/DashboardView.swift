// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DashboardView: View {
    let concourseURL: URL
    
    @Environment(\.openURL) private var openURL

    var body: some View {
        Button(action: {
            openURL(concourseURL)
        }, label: {
            HStack {
                Image(systemName: kIconDashboard)
                Spacer()
                Text(concourseURL.absoluteString)
            }
        })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(concourseURL: URL(string: "http://localhost/")!)
    }
}
