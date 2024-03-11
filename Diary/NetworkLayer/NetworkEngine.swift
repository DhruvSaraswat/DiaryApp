//
//  NetworkEngine.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation

protocol NetworkEngine {
    func request<T: Codable>(request: APIRequest, completion: ((Result<T?, APIError>) -> Void)?)
}

struct NetworkEngineImpl: NetworkEngine {
    private let urlSession: URLSession
    private let successStatusCodeRange = 200...299

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func request<T: Codable>(request: APIRequest, completion: ((Result<T?, APIError>) -> Void)?) {
        guard let urlRequest = buildURLRequest(from: request) else {
            completion?(.failure(.requestCreationFailed))
            return
        }

        let dataTask = urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            guard error == nil else {
                completion?(.failure(.serverError(error: error!)))
                return
            }

            if let httpResponse = urlResponse as? HTTPURLResponse, !successStatusCodeRange.contains(httpResponse.statusCode) {
                completion?(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let responseData = data, !responseData.isEmpty else {
                completion?(.success(nil))
                return
            }

            if let responseObject = try? JSONDecoder().decode(T.self, from: responseData) {
                completion?(.success(responseObject))
            } else {
                completion?(.failure(.unableToParseResponse(data: responseData)))
            }
        }
        dataTask.resume()
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
