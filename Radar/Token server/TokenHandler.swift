// SPDX-License-Identifier: Apache-2.0

import Foundation
import NIOHTTP1
import NIOCore

class TokenHandler: ChannelInboundHandler {
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart

    private let successReply = ""
    private let failureReply = htmlBody("Radar was unable to retrieve the token. Please <a href=\"javascript:history.back()\">go back</a>, copy the token, and paste it in Radar's preferences window.")

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let reqPart = unwrapInboundIn(data)

        switch reqPart {
        case .head(let request):
            handleTokenRequest(request: request, context: context)
        case .body, .end: // the only expected data is the request URL
            break
        }
    }

    private func handleTokenRequest(request: HTTPRequestHead, context: ChannelHandlerContext) {
        var status = HTTPResponseStatus.ok

        if request.method == HTTPMethod.GET {
            if let token = request.uri.extractToken() {
                setToken(token)
            } else {
                print("||| token not found in request uri \(request.uri)")
                status = .expectationFailed
            }
        }
        let reply = status == .ok ? successReply : failureReply

        var headers = HTTPHeaders()
        if request.method == HTTPMethod.GET && status == .ok, let url = URL(string: Settings.concourseUrl) {
            headers.add(name: "Location", value: url.appending(component: "fly_success").appending(queryItems: [URLQueryItem(name: "noop", value: "true")]).absoluteString)
            status = .movedPermanently
        } else {
            headers.add(name: "Access-Control-Allow-Origin", value: Settings.concourseUrl)
            headers.add(name: "Content-Type", value: "text/html; charset=utf-8")
            headers.add(name: "Content-Length", value: String(reply.lengthOfBytes(using: .utf8)))
        }
        let head = HTTPResponseHead(version: request.version, status: status, headers: headers)
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        context.write(wrapOutboundOut(.body(.byteBuffer(ByteBuffer(string: reply)))), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }


    private func setToken(_ token: String) {
        let defaults = UserDefaults()
        defaults.set(token, forKey: kBearerToken)
        defaults.synchronize()
    }

}

fileprivate func htmlBody(_ body: String) -> String {
    "<html><head><title>Radar says...</title></head><body>\(body)</body></html>"
}

