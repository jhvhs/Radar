// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ConcourseMenu: View {
    @EnvironmentObject var concourseData: ConcourseData
    @EnvironmentObject var tokenServer: HTTPTokenServer

    var body: some View {
        VStack {
            if let url = concourseData.concourseUrl, let validURL = URL(string: url) {
                DashboardView(concourseURL: validURL)

                if let team = concourseData.team?.teamName {
                    Text(team)
                    Divider()
                }

                if let _ = concourseData.team?.error {
                    FetchTokenView(baseURL: concourseData.team!.concourseUrl, serverPort: tokenServer.port)
                } else {
                    if let team = concourseData.team {
                        ForEach(team.pipelines) { p in
                            PipelineView(pipeline: p)
                        }

                    }
                }

                Divider()
            }
        }
    }
}


struct ConcourseMenu_Previews: PreviewProvider {
    static var previews: some View {
        return ConcourseMenu()
                .environmentObject(fullConcourseData())
                .environmentObject(HTTPTokenServer())
                .previewDisplayName("Full menu")
    }
}

struct ConcourseMenuTokenFetch_Previews: PreviewProvider {
    static var previews: some View {
        ConcourseMenu()
                .environmentObject(unauthorisedConcourseData())
                .environmentObject(HTTPTokenServer())
                .previewDisplayName("Token fetch menu")
    }
}

struct ConcourseMenuNoTeamSet_Previews: PreviewProvider {
    static var previews: some View {
        ConcourseMenu()
                .environmentObject(concourseDataWithoutTeam())
                .environmentObject(HTTPTokenServer())
                .previewDisplayName("Team not set")
    }
}

struct ConcourseMenuEmpty_Previews: PreviewProvider {
    static var previews: some View {
        ConcourseMenu()
                .environmentObject(ConcourseData())
                .environmentObject(HTTPTokenServer())
                .previewDisplayName("Empty menu")
    }
}


fileprivate func unauthorisedConcourseData() -> ConcourseData {
    let data = ConcourseData()
    data.concourseUrl = "http://localhost/"
    data.team = Team(concourseUrl: URL(string: "http://localhost")!, teamName: "test-team", pipelines: [], error: ConcourseDataFetcher.FetcherError.authenticationError)
    return data
}

fileprivate func fullConcourseData() -> ConcourseData {
    let data = ConcourseData()
    data.concourseUrl = "http://localhost/"
    data.team = Team(concourseUrl: URL(string: "http://localhost")!, teamName: "test-team", pipelines: [
        Pipeline(id: 1, name: "pipeline-name", isPaused: false, isPublic: false, concourseUrl: URL(string: "http://localhost")!, teamName: "test-team", jobs: [
            Job(id: 1, name: "test-job", transitionBuild: nil, finishedBuild: Build(id: 1, name: "234", status: .succeeded,
                    startTime: Date(timeIntervalSince1970: 298347), endTime: Date(timeIntervalSince1970: 948559)), nextBuild: nil)
        ]),
        Pipeline(id: 2, name: "pipeline-two", isPaused: false, isPublic: false, concourseUrl: URL(string: "http://localhost")!, teamName: "test-team", jobs: [
            Job(id: 21, name: "another-test-job", transitionBuild: nil,
                finishedBuild: nil,
                nextBuild: Build(id: 213, name: "29873", status: .started,
                    startTime: Date(timeIntervalSince1970: 9879347), endTime: Date(timeIntervalSince1970: 98758974)))
        ])
    ], error: nil)
    return data
}

fileprivate func concourseDataWithoutTeam() -> ConcourseData {
    let data = ConcourseData()
    data.concourseUrl = "http://localhost/"
    return data
}
