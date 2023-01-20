// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct PreferencesView: View {
    @AppStorage(kConcourseURL) var concourseURL: String = ""
    @AppStorage(kBearerToken) var token: String = ""
    @AppStorage(kTeamName) var teamName: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("Concourse URL preferences window label", comment: ""))
            TextField(NSLocalizedString("Concourse URL preferences window label", comment: ""), text: $concourseURL).padding(.bottom)
            Text(NSLocalizedString("Team name preferences window label", comment: ""))
            TextField(NSLocalizedString("Team name preferences window label", comment: ""), text: $teamName).padding(.bottom)
            Text(NSLocalizedString("Auth token preferences window label", comment: ""))
            SecureField(NSLocalizedString("Auth token preferences window label", comment: ""), text: $token).padding(.bottom)
        }
        .padding(.all)
        
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
