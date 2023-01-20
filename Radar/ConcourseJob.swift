// SPDX-License-Identifier: Apache-2.0

import Foundation

struct ConcourseBuild: Codable {
    var id: Int
    var name: String
    var status: String
    var start_time: Int
    var end_time: Int
    var team_name: String
    var pipeline_id: Int
    var pipeline_name: String
    var job_name: String
}

struct JobInput: Codable {
    var name: String
    var resource: String
    var trigger: Bool?
    var passed: [String]?
}

struct ConcourseJob: Codable, Identifiable {
    var id: Int
    var name: String
    var team_name: String
    var pipeline_id: Int
    var pipeline_name: String
    var finished_build: ConcourseBuild?
    var transition_build: ConcourseBuild?
    var next_build: ConcourseBuild?
    var inputs: [JobInput]?
}
