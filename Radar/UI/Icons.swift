// SPDX-License-Identifier: Apache-2.0

import Foundation

enum Icon: String {
    case paused = "pause.circle.fill"
    case failed = "xmark.octagon"
    case running = "figure.run.circle"
    case incompleteSuccess = "checkmark.circle.badge.questionmark"
    case pending = "hourglass.circle"
    case success = "checkmark.circle.fill"
    case unknown = "questionmark.app.dashed"
    
    static func forStatus(_ c: Self) -> String {
        c.rawValue
    }
}

let kIconDashboard = "rectangle.grid.3x2.fill"
let kIconLogin = "key.horizontal.fill"
