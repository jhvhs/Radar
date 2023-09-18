// SPDX-License-Identifier: Apache-2.0

import Foundation

typealias ConcourseDataFetcherFactory = (String, String, String) -> GenericConcourseDataFetcher


func networkDataFetcherFactory(urlString: String, teamName: String, token: String) -> GenericConcourseDataFetcher {
    ConcourseDataFetcher(concourseURLString: urlString, teamName: teamName, concourseToken: token)
}

protocol GenericConcourseDataFetcher {
    func fetchAllData() async throws -> ([ConcoursePipeline], [ConcourseJob])
}

class ConcourseDataFetcher: NSObject, URLSessionTaskDelegate, GenericConcourseDataFetcher {
    enum FetcherError: Error {
        case decodeError(entity: String)
        case downloadError(entity: String)
        case authenticationError
        case configurationError
    }

    var concourseURLString: String
    var concourseToken: String

    init(concourseURLString: String, teamName: String, concourseToken: String) {
        self.concourseURLString = concourseURLString
        self.concourseToken = concourseToken
    }

    private var concourseURL: URL {
        URL(string: concourseURLString)!
    }

    private var pipelinesURL: URL {
        concourseURL.appending(components: "api", "v1", "pipelines")
    }

    private var teamsURL: URL {
        concourseURL.appending(components: "api", "v1", "teams")
    }

    private var jobsURL: URL {
        concourseURL.appending(components: "api", "v1", "jobs")
    }

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        let headers: [AnyHashable: Any] = [
            "Authorization": self.concourseToken,
            "Referer": self.concourseURLString,
            "Host": self.concourseURL.host()!
        ]
        config.httpAdditionalHeaders = headers
        return URLSession(configuration: config, delegate: self, delegateQueue: .main)
    }()


    func fetchAllData() async throws -> ([ConcoursePipeline], [ConcourseJob]) {
        guard self.concourseURL.host() != nil else { throw FetcherError.configurationError }
        let (teamData, teamResponse) = try await session.data(from: teamsURL)
        if (teamResponse as! HTTPURLResponse).isUnauthorized {
            throw FetcherError.authenticationError
        }
        
        let teams = try JSONDecoder().decode([ConcourseTeam].self, from: teamData)
        if teams.isEmpty {
            throw FetcherError.authenticationError
        }

        async let (pipelineData, _) = session.data(from: pipelinesURL)
        async let (jobData, _) = session.data(from: jobsURL)

        let data = await [try pipelineData, try jobData]

        let pipelines = try JSONDecoder().decode([ConcoursePipeline].self, from: data[0])
        let jobs = try JSONDecoder().decode([ConcourseJob].self, from: data[1])
        
        return (pipelines, jobs)
    }

}


extension HTTPURLResponse {
    var isUnauthorized: Bool {
        [401, 403].contains(statusCode)
    }
}
