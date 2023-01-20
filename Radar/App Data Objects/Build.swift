// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Build {
    enum Status: String {
        case aborted
        case errored
        case failed
        case started
        case succeeded
    }

    let id: Int
    let name: String
    let status: Status
    let startTime: Date
    let endTime: Date
}
