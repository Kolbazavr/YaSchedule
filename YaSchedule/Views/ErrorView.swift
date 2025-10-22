//
//  ErrorView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 20.10.2025.
//

import SwiftUI
import OpenAPIRuntime

enum ErrorView: View {
    case noInternet
    case serverError
    case custom(Error)
    
    init(error: Error) {
        switch error {
        case is ServerError:
            self = .serverError
        case is URLError:
            self = .noInternet
        case is ClientError:
            self = .noInternet
        default:
            self = .custom(error)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                switch self {
                case .noInternet:
                    Image(.noInternet)
                    Text("Нет интернета")
                case .serverError:
                    Image(.serverError)
                    Text("Ошибка сервера")
                case .custom(let error):
                    Image(systemName: "exclamationmark.triangle")
                    Text("Unknown error: \(error)")
                }
            }
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(AppColors.text.color)
        }
    }
}

#Preview {
    ErrorView(error: ServerError(
        operationID: "operationID",
        request: .init(method: .get, scheme: "", authority: "", path: ""),
        requestBody: nil,
        requestMetadata: .init(),
        causeDescription: "Cause Description",
        underlyingError: NSError(domain: "12", code: 123, userInfo: nil)
    ))
}

#Preview {
    ErrorView(error: URLError(.badURL))
}
