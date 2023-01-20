// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FetchTokenView: View {
    let baseURL: URL
    let serverPort: Int?
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button(action: {
            let tokenURL = baseURL.appending(path: "login").appending(queryItems: [URLQueryItem(name: "fly_port", value: String(serverPort ?? 10293))])
            openURL(tokenURL)
        }, label: {
            HStack {
                Image(systemName: kIconLogin)
                Spacer()
                Text(NSLocalizedString("Fetch token menu item label", comment: ""))
            }
        })
    }
}

struct FetchTokenView_Previews: PreviewProvider {
    static var previews: some View {
        FetchTokenView(baseURL: URL(string: "http://localhost")!, serverPort: nil)
    }
}
