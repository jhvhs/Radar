// SPDX-License-Identifier: Apache-2.0

import Quick
import Nimble
import Foundation
@testable import Radar

class AppDataConverterSpec: QuickSpec {
    let url = URL(string: "http://localhost")!
    let teamName = "test-team"
    
    override func spec() {
        it("assigns the URL and teamName to the Team") {
            let team = AppDataConverter.convert(pipelines: [], jobs: [], url: self.url, teamName: self.teamName)
            expect(team.concourseUrl).to(equal(self.url))
            expect(team.teamName).to(equal(self.teamName))
        }
        
        it("includes the pipelines and jobs") {
            let pipeline = ConcoursePipeline(id: 1, name: "test-pipeline", paused: false, archived: false, public: false, team_name: self.teamName)
            let successfulBuild = ConcourseBuild(id: 1, name: "1", status: "succeeded", start_time: 23894, end_time: 30983, team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", job_name: "test-job")

            let job = ConcourseJob(id: 1, name: "test-job", team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", finished_build: successfulBuild)
            
            let team = AppDataConverter.convert(pipelines: [pipeline], jobs: [job], url: self.url, teamName: self.teamName)
            expect(team.pipelines).to(haveCount(1))
            expect(team.pipelines.first!.jobs).to(haveCount(1))
        }

        it("omits archived pipelines") {
            let pipeline = ConcoursePipeline(id: 1, name: "test-pipeline", paused: false, archived: true, public: false, team_name: self.teamName)
            let team = AppDataConverter.convert(pipelines: [pipeline], jobs: [], url: self.url, teamName: self.teamName)
            expect(team.pipelines).to(beEmpty())
        }

        it("assigns the attributes to pipeline") {
            let concoursePipeline = ConcoursePipeline(id: 1, name: "test-pipeline", paused: false, archived: false, public: false, team_name: self.teamName)

            let team = AppDataConverter.convert(pipelines: [concoursePipeline], jobs: [], url: self.url, teamName: self.teamName)
            let pipeline = team.pipelines.first!
            expect(pipeline.id).to(equal(1))
            expect(pipeline.name).to(equal("test-pipeline"))
            expect(pipeline.paused).to(beFalse())
            expect(pipeline.public).to(beFalse())
            expect(pipeline.concourseUrl).to(equal(self.url))
            expect(pipeline.teamName).to(equal(self.teamName))
        }

        it("assigns the attributes to the job") {
            let concoursePipeline = ConcoursePipeline(id: 1, name: "test-pipeline", paused: false, archived: false, public: false, team_name: self.teamName)
            let transitionBuild = ConcourseBuild(id: 1, name: "1", status: "succeeded", start_time: 23894, end_time: 30983, team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", job_name: "test-job")
            let finishedBuild = ConcourseBuild(id: 12, name: "12", status: "succeeded", start_time: 52834, end_time: 85465, team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", job_name: "test-job")
            let nextBuild = ConcourseBuild(id: 13, name: "13", status: "started", start_time: 49764, end_time: 46546, team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", job_name: "test-job")

            let concourseJob = ConcourseJob(id: 1, name: "test-job", team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", finished_build: finishedBuild, transition_build: transitionBuild, next_build: nextBuild)

            let team = AppDataConverter.convert(pipelines: [concoursePipeline], jobs: [concourseJob], url: self.url, teamName: self.teamName)
            let job = team.pipelines.first!.jobs.first!
            expect(job.id).to(equal(1))
            expect(job.name).to(equal("test-job"))
            expect(job.finishedBuild).toNot(beNil())
            expect(job.transitionBuild).toNot(beNil())
            expect(job.nextBuild).toNot(beNil())
        }

        it("assigns the attributes to the builds") {
            let concoursePipeline = ConcoursePipeline(id: 1, name: "test-pipeline", paused: false, archived: false, public: false, team_name: self.teamName)
            let tBuild = ConcourseBuild(id: 1, name: "1", status: "succeeded", start_time: 23894, end_time: 30983, team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", job_name: "test-job")
            let fBuild = ConcourseBuild(id: 12, name: "12", status: "succeeded", start_time: 52834, end_time: 85465, team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", job_name: "test-job")
            let nBuild = ConcourseBuild(id: 13, name: "13", status: "started", start_time: 49764, end_time: 46546, team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", job_name: "test-job")

            let concourseJob = ConcourseJob(id: 1, name: "test-job", team_name: self.teamName, pipeline_id: 1, pipeline_name: "test-pipeline", finished_build: fBuild, transition_build: tBuild, next_build: nBuild)

            let team = AppDataConverter.convert(pipelines: [concoursePipeline], jobs: [concourseJob], url: self.url, teamName: self.teamName)
            let job = team.pipelines.first!.jobs.first!

            let transitionBuild = job.transitionBuild!
            let finishedBuild = job.finishedBuild!
            let nextBuild = job.nextBuild!

            expect(transitionBuild.id).to(equal(1))
            expect(transitionBuild.name).to(equal("1"))
            expect(transitionBuild.status).to(equal(.succeeded))
            expect(transitionBuild.startTime).to(equal(Date(timeIntervalSince1970: 23894)))
            expect(transitionBuild.endTime).to(equal(Date(timeIntervalSince1970: 30983)))

            expect(finishedBuild.id).to(equal(12))
            expect(finishedBuild.name).to(equal("12"))
            expect(finishedBuild.status).to(equal(.succeeded))
            expect(finishedBuild.startTime).to(equal(Date(timeIntervalSince1970: 52834)))
            expect(finishedBuild.endTime).to(equal(Date(timeIntervalSince1970: 85465)))

            expect(nextBuild.id).to(equal(13))
            expect(nextBuild.name).to(equal("13"))
            expect(nextBuild.status).to(equal(.started))
            expect(nextBuild.startTime).to(equal(Date(timeIntervalSince1970: 49764)))
            expect(nextBuild.endTime).to(equal(Date(timeIntervalSince1970: 46546)))
        }

        it("includes only pipelines from the indicated team") {
            let pipelines = [
                ConcoursePipeline(id: 1, name: "name-1", paused: false, archived: false, public: false, groups: nil, team_name: "test-team", last_updated: nil),
                ConcoursePipeline(id: 1, name: "name-1", paused: false, archived: false, public: false, groups: nil, team_name: "not-test-team", last_updated: nil),
                ConcoursePipeline(id: 1, name: "name-1", paused: false, archived: false, public: false, groups: nil, team_name: "not-test-team", last_updated: nil),
                ConcoursePipeline(id: 1, name: "name-1", paused: false, archived: false, public: false, groups: nil, team_name: "another-test-team", last_updated: nil),
                ConcoursePipeline(id: 1, name: "name-1", paused: false, archived: false, public: false, groups: nil, team_name: "test-team", last_updated: nil),
            ]

            let team = AppDataConverter.convert(pipelines: pipelines, jobs: [], url: URL(string: "http://localhost")!, teamName: "test-team")
            expect(team.pipelines).to(haveCount(2))
        }
    }
}
