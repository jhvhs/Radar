// SPDX-License-Identifier: Apache-2.0

import Foundation
import NIOHTTP1
import NIOPosix
import NIOCore

class HTTPTokenServer: ObservableObject {
    private var bootstrap: ServerBootstrap!
    private var group: MultiThreadedEventLoopGroup!
    @Published var port: Int?
    @Published var token: String?
    
    func setupListenAndWait() -> Self {
        DispatchQueue.global(qos: .userInitiated).async {
            self._setupListenAndWait()
        }
        return self
    }
    
    private func _setupListenAndWait() {
        group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        
        bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline().flatMap { () in
                    channel.pipeline.addHandler(TokenHandler())
                }
            }
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
        
        let channel = try! bootstrap.bind(host: "127.0.0.1", port: 0).wait()
        print("Waiting for connections on \(String(describing: channel.localAddress))")
        
        DispatchQueue.main.schedule {
            self.port = channel.localAddress?.port
        }
        
        try! channel.closeFuture.wait()
    }
    
    func shutdownGracefully() throws {
        try! group.syncShutdownGracefully()
    }
    
}
