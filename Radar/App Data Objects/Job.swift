// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Job {
    enum Status: String, Comparable {
        case aborted
        case errored
        case failed
        case started
        case succeeded
        case unknown

        static func <(lhs: Job.Status, rhs: Job.Status) -> Bool {
            lhs.comparisonValue < rhs.comparisonValue
        }

        private var comparisonValue: Int {
            switch self {
            case .unknown:
                return 3
            case .succeeded:
                return 2
            case .started:
                return 1
            default:
                return 0
            }
        }
    }

    let id: Int
    let name: String

    let transitionBuild: Build?

    let finishedBuild: Build?
    let nextBuild: Build?

    var status: Status {
        if let nextBuild {
            return Status(rawValue: nextBuild.status.rawValue)!
        }
        if let finishedBuild {
            return Status(rawValue: finishedBuild.status.rawValue)!
        }
        return .unknown
    }
}

// Considerations for the job status
//
// Ignore transition build for now
// next == nil && finished == nil => .unknown
// next == nil
//   finished.status (aborted,errored,failed or succeeded)
// else
//   next.status

// job status
// next_build not nil -> pending
// transition_build not nil -> transition_build.status
// finished_build not nil -> finished_build.status
// otherwise -> blank status
