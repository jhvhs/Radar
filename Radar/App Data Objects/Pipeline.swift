// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Pipeline: Identifiable {
    let id: Int
    let name: String
    let paused: Bool
    let `public`: Bool
    let concourseUrl: URL
    let teamName: String


    let jobs: [Job]

    var url: URL {
        concourseUrl.appending(components: "teams", teamName, "pipeline", name)
    }

    var statusIcon: Icon {
        if paused {
            return .paused
        }
        if jobs.isEmpty {
            return .unknown
        }
        switch jobs.map({ job -> Job.Status in job.status }).sorted().first! {
        case .unknown:
            return .unknown
        case .failed:
            return .failed
        case .succeeded:
            return .success
        case .started:
            return .running
        case .errored:
            return .failed
        case .aborted:
            return .unknown
        }
    }
}
