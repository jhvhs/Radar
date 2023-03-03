// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct PipelineView: View {
    let pipeline: Pipeline
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button(action: {
            openURL(pipeline.url)
        }, label: {
            HStack {
                Image(systemName: pipeline.statusIcon.rawValue)
                Spacer()
                Text(pipeline.name)
            }
        })
    }
}

struct PipelineView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineView(pipeline: Pipeline(id: 1, name: "pipeline-name", isPaused: false, isPublic: false, concourseUrl: URL(string: "http://localhost")!, teamName: "preview-team", jobs: [
            Job(id: 1, name: "", transitionBuild: nil, finishedBuild: Build(id: 1, name: "", status: .succeeded, startTime: Date(), endTime: Date()), nextBuild: nil)
        ]))
    }
}
