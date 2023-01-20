// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import Radar

func buildWithStatus(_ status: Build.Status) -> Build {
    Build(id: 1, name: "", status: status, startTime: Date(), endTime: Date())
}

func jobWithStatus(_ status: Job.Status) -> Job {
    if status == .unknown {
        return Job(id: 1, name: "", transitionBuild: nil, finishedBuild: nil, nextBuild: nil)
    }
    let build =  Build(id: 1, name: "", status: Build.Status(rawValue: status.rawValue)!, startTime: Date(), endTime: Date())
    if status == .started {
        return Job(id: 1, name: "", transitionBuild: nil, finishedBuild: nil, nextBuild: build)
    }
    return Job(id: 1, name: "", transitionBuild: nil, finishedBuild: build, nextBuild: nil)
}