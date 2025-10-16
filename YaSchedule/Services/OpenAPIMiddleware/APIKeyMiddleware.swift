//
//  APIKeyMiddleware.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 13.10.2025.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

struct APIKeyMiddleware: ClientMiddleware {
    private let apiKey: String = Secrets.apiKey
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var modifiedRequest = request
        modifiedRequest.headerFields[.authorization] = apiKey
        return try await next(modifiedRequest, body, baseURL)
    }
}
