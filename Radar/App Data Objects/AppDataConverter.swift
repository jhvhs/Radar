// SPDX-License-Identifier: Apache-2.0

import Foundation

class AppDataConverter {
    static func convert(pipelines concoursePipelines: [ConcoursePipeline], jobs concourseJobs: [ConcourseJob], url: URL, teamName: String) -> Team {
        let indexedJobs = sortConcourseJobs(jobs: concourseJobs, teamName: teamName)
        var pipelineCollection = [Pipeline]()
        for concoursePipeline in concoursePipelines.filter({ !$0.isArchived && ($0.teamName == teamName) }) {
            var pipelineJobs = [Job]()
            if let jobCollection = indexedJobs[concoursePipeline.id] {
                for j in jobCollection {
                    pipelineJobs.append(extractJob(j))
                }
            }
            pipelineCollection.append(Pipeline(id: concoursePipeline.id, name: concoursePipeline.name, isPaused: concoursePipeline.isPaused, isPublic: concoursePipeline.isPublic, concourseUrl: url, teamName: teamName, jobs: pipelineJobs))
        }
        return Team(concourseUrl: url, teamName: teamName, pipelines: pipelineCollection, error: nil)
    }

    private static func extractJob(_ job: ConcourseJob) -> Job {
        Job(id: job.id,
                name: job.name,
                transitionBuild: extractBuild(job.transitionBuild),
                finishedBuild: extractBuild(job.finishedBuild),
                nextBuild: extractBuild(job.nextBuild)
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
                startTime: Date(timeIntervalSince1970: Double(concourseBuild.startTime)),
                endTime: Date(timeIntervalSince1970: Double(concourseBuild.endTime)))
    }

    private static func sortConcourseJobs(jobs: [ConcourseJob], teamName: String) -> [Int: [ConcourseJob]] {
        var result = [Int: [ConcourseJob]]()
        for job in jobs.filter({ $0.teamName == teamName }) {
            if result[job.pipelineId] == nil {
                result[job.pipelineId] = [ConcourseJob]()
            }
            result[job.pipelineId]?.append(job)
        }
        return result
    }
}
