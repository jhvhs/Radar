// SPDX-License-Identifier: Apache-2.0

import Foundation

struct PipelineGroup: Codable {
    var name: String
    var jobs: [String]
}

struct ConcoursePipeline: Codable {
    var id: Int
    var name: String
    var paused: Bool
    var archived: Bool
    var `public`: Bool
    var groups: [PipelineGroup]?
    var team_name: String
    var last_updated: Int?
}