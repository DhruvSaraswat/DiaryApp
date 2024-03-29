//
//  NetworkEngine.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation

protocol NetworkEngine {
    func request<T: Codable>(request: APIRequest) async -> (Result<T?, APIError>)
}

struct NetworkEngineImpl: NetworkEngine {
    private let urlSession: URLSession
    private let successStatusCodeRange = 200...299

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func request<T: Codable>(request: APIRequest) async -> (Result<T?, APIError>) {
        guard let urlRequest = buildURLRequest(from: request) else {
            return .failure(.requestCreationFailed)
        }

        var apiResponse: (data: Data, urlResponse: URLResponse)

        do {
            apiResponse = try await urlSession.data(for: urlRequest)
        } catch {
            return .failure(.serverError(error: error))
        }

        if let httpResponse = apiResponse.urlResponse as? HTTPURLResponse, !successStatusCodeRange.contains(httpResponse.statusCode) {
            return .failure(.serverError(statusCode: httpResponse.statusCode))
        }

        guard !apiResponse.data.isEmpty else {
            return .success(nil)
        }

        if let responseObject = try? JSONDecoder().decode(T.self, from: apiResponse.data) {
            return .success(responseObject)
        }
        return .failure(.unableToParseResponse(data: apiResponse.data))
    }

    func buildURLRequest(from apiRequest: APIRequest) -> URLRequest? {
        var components = URLComponents()
        components.scheme = apiRequest.scheme
        components.host = apiRequest.baseURL
        components.port = apiRequest.port
        components.path = apiRequest.path
        components.queryItems = apiRequest.queryParameters

        guard let url = components.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue
        apiRequest.headers?.forEach { headerName, headerValue in
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerName)
        }

        if let requestBody = apiRequest.requestBody {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
                urlRequest.httpBody = jsonData
            } catch {
                return nil
            }
        }

        return urlRequest
    }
}
