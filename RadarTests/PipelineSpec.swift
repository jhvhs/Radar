// SPDX-License-Identifier: Apache-2.0

import Quick
import Nimble
import Foundation
@testable import Radar

class PipelineSpec: QuickSpec {
    override func spec() {
        it("returns the pipeline URL") {
            let pipeline = Pipeline(id: 1, name: "pipeline-name", paused: false, public: false, concourseUrl: URL(string: "http://localhost")!, teamName: "test-team", jobs: [])
            expect(pipeline.url).to(equal(URL(string: "http://localhost/teams/test-team/pipeline/pipeline-name")!))
        }

        describe("status") {
            it("is successful") {
                let pipeline = Pipeline(id: 1, name: "", paused: false, public: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [
                    jobWithStatus(.succeeded), jobWithStatus(.succeeded), jobWithStatus(.succeeded)
                ])

                expect(pipeline.statusIcon).to(equal(.success))
            }

            it("is failing") {
                let pipeline = Pipeline(id: 1, name: "", paused: false, public: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [
                    jobWithStatus(.succeeded), jobWithStatus(.failed)
                ])

                expect(pipeline.statusIcon).to(equal(.failed))
            }

            it("is paused") {
                let pipeline = Pipeline(id: 1, name: "", paused: true, public: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [])

                expect(pipeline.statusIcon).to(equal(.paused))
            }

            it("is running") {
                let pipeline = Pipeline(id: 1, name: "", paused: false, public: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [
                    jobWithStatus(.succeeded), jobWithStatus(.started)
                ])

                expect(pipeline.statusIcon).to(equal(.running))
            }

            it("is failing if there's an errored job") {
                let pipeline = Pipeline(id: 1, name: "", paused: false, public: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [
                    jobWithStatus(.succeeded), jobWithStatus(.errored)
                ])

                expect(pipeline.statusIcon).to(equal(.failed))
            }

            it("is unknown if there's an aborted job") {
                let pipeline = Pipeline(id: 1, name: "", paused: false, public: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [
                    jobWithStatus(.succeeded), jobWithStatus(.aborted)
                ])

                expect(pipeline.statusIcon).to(equal(.unknown))
            }
        }
    }
}