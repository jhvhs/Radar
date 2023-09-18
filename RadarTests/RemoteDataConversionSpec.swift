// SPDX-License-Identifier: Apache-2.0

import Quick
import Nimble
import Foundation
@testable import Radar

class RemoteDataConversionSpec: QuickSpec {
    let samplePipelines = "[{\"id\": 33937,\"name\": \"slack-delegate-bot\",\"paused\": false,\"public\": false,\"archived\": false,\"team_name\": \"dash-core\",\"last_updated\": 1694500551}]"
    let sampleJobs = "[{\"id\":87813,\"name\":\"build-and-push-image\",\"team_name\":\"davros\",\"pipeline_id\":3845,\"pipeline_name\":\"davros\",\"groups\":[\"secondary\",\"all\"],\"finished_build\":{\"id\":1420927292,\"name\":\"27.1\",\"status\":\"succeeded\",\"start_time\":1671440226,\"end_time\":1671440994,\"team_name\":\"davros\",\"pipeline_id\":3845,\"pipeline_name\":\"davros\",\"job_name\":\"build-and-push-image\"},\"transition_build\":{\"id\":1420927292,\"name\":\"27.1\",\"status\":\"succeeded\",\"start_time\":1671440226,\"end_time\":1671440994,\"team_name\":\"davros\",\"pipeline_id\":3845,\"pipeline_name\":\"davros\",\"job_name\":\"build-and-push-image\"},\"inputs\":[{\"name\":\"master-image-src\",\"resource\":\"master-image-src\"}],\"outputs\":[{\"name\":\"master-image\",\"resource\":\"master-image\"}]}]"
    let sampleTeams = "[{\"id\":2385,\"name\":\"cybergenics\",\"auth\":{\"member\":{\"groups\":[],\"users\":[\"this\",\"is\",\"the\",\"house\",\"that\",\"jack\",\"built\",\"malt\",\"lay\",\"rat\"]},\"owner\":{\"groups\":[],\"users\":[\"local:worker\",\"local:concourse\"]},\"pipeline-operator\":{\"groups\":[],\"users\":[\"pipeline-user\",\"operator-user\"]},\"viewer\":{\"groups\":[],\"users\":[\"viewer-user\"]}}}]"
    
    override func spec() {
        it("converts pipelines from JSON") {
            expect { try JSONDecoder().decode([ConcoursePipeline].self, from: self.samplePipelines.data(using: .utf8)!) }.notTo(throwError())
        }
        
        it("converts jobs from JSON") {
            expect { try JSONDecoder().decode([ConcourseJob].self, from: self.sampleJobs.data(using: .utf8)!) }.notTo(throwError())
        }
        
        it("converts teams from JSON") {
            expect { try JSONDecoder().decode([ConcourseTeam].self, from: self.sampleTeams.data(using: .utf8)!) }.notTo(throwError())
        }
    }
}
