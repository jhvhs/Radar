// SPDX-License-Identifier: Apache-2.0

import Quick
import Nimble
import Foundation
@testable import Radar

class TeamSpec: QuickSpec {
    override func spec() {
        describe("status icon") {
            it("is unknown when there's an error") {
                let team = Team(concourseUrl: URL.cachesDirectory, teamName: "", pipelines: [], error: URLError(.unknown))
                expect(team.statusIcon).to(equal(.unknown))
            }

            for jobStatus: Job.Status in [.failed, .errored] {
                it("is failed if there's \(jobStatus == .failed ? "a" : "an") \(jobStatus) job") {
                    let team = Team(concourseUrl: URL.cachesDirectory, teamName: "", pipelines: [
                        Pipeline(id: 1, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                        Pipeline(id: 2, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                        Pipeline(id: 3, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(jobStatus)]),
                    ], error: nil)

                    expect(team.statusIcon).to(equal(.failed))
                }
            }

            it("is successful if all pipelines are successful") {
                let team = Team(concourseUrl: URL.cachesDirectory, teamName: "", pipelines: [
                    Pipeline(id: 1, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                    Pipeline(id: 2, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                    Pipeline(id: 3, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                ], error: nil)

                expect(team.statusIcon).to(equal(.success))
            }

            it("is successful for a mix of successful of un-started pipelines") {
                let team = Team(concourseUrl: URL.cachesDirectory, teamName: "", pipelines: [
                    Pipeline(id: 1, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                    Pipeline(id: 2, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.unknown)]),
                    Pipeline(id: 3, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                ], error: nil)

                expect(team.statusIcon).to(equal(.success))
            }

            it("is disregarding the paused pipelines") {
                let team = Team(concourseUrl: URL.cachesDirectory, teamName: "", pipelines: [
                    Pipeline(id: 1, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                    Pipeline(id: 2, name: "", isPaused: true, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                    Pipeline(id: 3, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                ], error: nil)

                expect(team.statusIcon).to(equal(.success))
            }

            it("is disregarding running pipelines") {
                let team = Team(concourseUrl: URL.cachesDirectory, teamName: "", pipelines: [
                    Pipeline(id: 1, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                    Pipeline(id: 2, name: "", isPaused: true, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.started)]),
                    Pipeline(id: 3, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)]),
                ], error: nil)

                expect(team.statusIcon).to(equal(.success))
            }

            it("is unknown for an absent team") {
                var team: Team?
                expect(team.statusIcon).to(equal(.unknown))
            }

            it("is reflects the status icon for a present team") {
                var team: Team?
                team = Team(concourseUrl: URL.cachesDirectory, teamName: "", pipelines: [
                    Pipeline(id: 1, name: "", isPaused: false, isPublic: false, concourseUrl: URL.cachesDirectory, teamName: "", jobs: [jobWithStatus(.succeeded)])
                ], error: nil)
                expect(team.statusIcon).to(equal(.success))
            }
        }
    }
}
