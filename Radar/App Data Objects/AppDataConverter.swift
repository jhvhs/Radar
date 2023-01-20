// SPDX-License-Identifier: Apache-2.0

import Foundation

class AppDataConverter {
    static func convert(pipelines concoursePipelines: [ConcoursePipeline], jobs concourseJobs: [ConcourseJob], url: URL, teamName: String) -> Team {
        let indexedJobs = sortConcourseJobs(jobs: concourseJobs, teamName: teamName)
        var pipelineCollection = [Pipeline]()
        for concoursePipeline in concoursePipelines.filter({ !$0.archived && ($0.team_name == teamName) }) {
            var pipelineJobs = [Job]()
            if let jobCollection = indexedJobs[concoursePipeline.id] {
                for j in jobCollection {
                    pipelineJobs.append(extractJob(j))
                }
            }
            pipelineCollection.append(Pipeline(id: concoursePipeline.id, name: concoursePipeline.name, paused: concoursePipeline.paused, public: concoursePipeline.public, concourseUrl: url, teamName: teamName, jobs: pipelineJobs))
        }
        return Team(concourseUrl: url, teamName: teamName, pipelines: pipelineCollection, error: nil)
    }

    private static func extractJob(_ job: ConcourseJob) -> Job {
        Job(id: job.id,
                name: job.name,
                transitionBuild: extractBuild(job.transition_build),
                finishedBuild: extractBuild(job.finished_build),
                nextBuild: extractBuild(job.next_build)
        )
    }

    private static func extractBuild(_ concourseBuild: ConcourseBuild?) -> Build? {
        guard let concourseBuild, let buildStatus = Build.Status(rawValue: concourseBuild.status) else {
            return nil
        }
        return Build(
                id: concourseBuild.id,
                name: concourseBuild.name,
                status: buildStatus,
                startTime: Date(timeIntervalSince1970: Double(concourseBuild.start_time)),
                endTime: Date(timeIntervalSince1970: Double(concourseBuild.end_time)))
    }

    private static func sortConcourseJobs(jobs: [ConcourseJob], teamName: String) -> [Int: [ConcourseJob]] {
        var result = [Int: [ConcourseJob]]()
        for job in jobs.filter({ $0.team_name == teamName }) {
            if result[job.pipeline_id] == nil {
                result[job.pipeline_id] = [ConcourseJob]()
            }
            result[job.pipeline_id]?.append(job)
        }
        return result
    }
}
