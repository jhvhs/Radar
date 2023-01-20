// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Team {
    let concourseUrl: URL
    let teamName: String
    let pipelines: [Pipeline]
    let error: Error?

    var statusIcon: Icon {
        if error != nil {
            return .unknown
        }
        let pipelineStatuses = pipelines.map { pipeline -> Icon in
            pipeline.statusIcon
        }
        if pipelineStatuses.contains(.failed) {
            return .failed
        }
        return .success
    }
}

extension Optional where Wrapped == Team {
    var statusIcon: Icon {
        switch self {
        case .none:
            return .unknown
        case .some(let team):
            return team.statusIcon
        }
    }
}
