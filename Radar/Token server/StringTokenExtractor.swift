// SPDX-License-Identifier: Apache-2.0

import Foundation

extension String {
    func extractToken() -> String? {
        if let _ = self.range(of: "^.*\\?token=", options: .regularExpression) {
            return self.replacingOccurrences(of: "^.*\\?token=", with: "", options: .regularExpression).removingPercentEncoding
        }
        return nil
    }
}
