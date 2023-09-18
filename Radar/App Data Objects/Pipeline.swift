// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Pipeline: Identifiable {
    let id: Int
    let name: String
    let isPaused: Bool
    let isPublic: Bool
    let concourseUrl: URL
    let teamName: String


    let jobs: [Job]

    var url: URL {
        concourseUrl.appending(components: "teams", teamName, "pipelines", name)
    }

    var statusIcon: Icon {
        if isPaused {
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
