// SPDX-License-Identifier: Apache-2.0

import Foundation
import Combine

class ConcourseData: ObservableObject {
    var fetcherFactory: ConcourseDataFetcherFactory
    @Published var team: Team?
    @Published var concourseUrl: String?
    @Published var teamName: String?
    @Published var error: Error?
    
    init(fetcherFactory: @escaping ConcourseDataFetcherFactory) {
        self.fetcherFactory = fetcherFactory
    }
    
    init() {
        fetcherFactory = networkDataFetcherFactory(urlString:teamName:token:)
    }
    
    private var timer: AnyCancellable?
    
    func startTimer() -> Self {
        timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect().sink { t in
            self.reload()
        }
        reload()
        return self
    }
    
    func reload() {
        refreshSettings()
        guard let url = URL(string: Settings.concourseUrl), let teamName = teamName else {
            team = nil
            error = URLError(.badURL)
            return
        }
        Task {
            let fetcher = ConcourseDataFetcher(concourseURLString: url.absoluteString, teamName: teamName, concourseToken: Settings.bearerToken)
            var pipelines = [ConcoursePipeline]()
            var jobs = [ConcourseJob]()
            do {
                (pipelines, jobs) = try await fetcher.fetchAllData()
            } catch ConcourseDataFetcher.FetcherError.authenticationError {
                self.setTeam(Team(concourseUrl: url, teamName: teamName, pipelines: [], error: ConcourseDataFetcher.FetcherError.authenticationError))
                return
            }
            
            self.setTeam(AppDataConverter.convert(pipelines: pipelines, jobs: jobs, url: url, teamName: teamName))
        }
    }
    
    private func setTeam(_ team: Team) {
        DispatchQueue.main.schedule {
            self.team = team
        }
    }

    private func refreshSettings() {
        concourseUrl = Settings.concourseUrl
        teamName = Settings.teamName
    }
}
