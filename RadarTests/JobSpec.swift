// SPDX-License-Identifier: Apache-2.0

import Quick
import Nimble
import Foundation
@testable import Radar

class JobSpec: QuickSpec {
    override func spec() {
        context("status") {
            it("is successful") {
                let job = Job(id: 1, name: "", transitionBuild: nil, finishedBuild: buildWithStatus(.succeeded), nextBuild: nil)

                expect(job.status).to(equal(.succeeded))
            }

            it("is unknown") {
                let job = Job(id: 1, name: "", transitionBuild: nil, finishedBuild: nil, nextBuild: nil)

                expect(job.status).to(equal(.unknown))
            }

            it("is failed") {
                let job = Job(id: 1, name: "", transitionBuild: nil, finishedBuild: buildWithStatus(.failed), nextBuild: nil)

                expect(job.status).to(equal(.failed))
            }

            it("is aborted") {
                let job = Job(id: 1, name: "", transitionBuild: nil, finishedBuild: buildWithStatus(.aborted), nextBuild: nil)

                expect(job.status).to(equal(.aborted))
            }

            it("is errored") {
                let job = Job(id: 1, name: "", transitionBuild: nil, finishedBuild: buildWithStatus(.errored), nextBuild: nil)

                expect(job.status).to(equal(.errored))
            }

            it("is started") {
                let job = Job(id: 1, name: "", transitionBuild: nil, finishedBuild: buildWithStatus(.succeeded), nextBuild: buildWithStatus(.started))

                expect(job.status).to(equal(.started))
            }

            describe("status comparison") {
                it("considers failed statuses to be more important than the rest") {
                    let failedStatusList: [Job.Status] = [.failed, .aborted, .errored]

                    for status in failedStatusList {
                        expect(status).to(beLessThan(.succeeded))
                        expect(status).to(beLessThan(.started))
                        expect(status).to(beLessThan(.unknown))
                    }
                }

                it("considers started status to be more important than succeeded or unknown") {
                    expect(Job.Status.started).to(beLessThan(.succeeded))
                    expect(Job.Status.started).to(beLessThan(.unknown))
                }

                it("considers succeeded status to be more important than unknown") {
                    expect(Job.Status.succeeded).to(beLessThan(.unknown))
                }
            }
        }
    }
}
