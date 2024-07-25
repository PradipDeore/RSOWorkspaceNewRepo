//
//  APIManager.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/02/24.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}
typealias ResultHandler<T> = (Result<T, DataError>) -> Void

final class APIManager {
    static let shared = APIManager()
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler
    
    init(networkHandler: NetworkHandler = NetworkHandler(),
         responseHandler: ResponseHandler = ResponseHandler()) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
    }
    
    func request<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        completion: @escaping ResultHandler<T>
    ) {
        guard let url = type.url else {
            completion(.failure(.invalidURL)) // I forgot to mention this in the video
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        
        if request.httpMethod == "GET" {
            if let parameters = type.body {
                guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase // Adjust as needed
                guard let data = try? encoder.encode(parameters) else { return }
                guard let queryParams = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                
                let queryItems = queryParams.map { key, value in
                    return URLQueryItem(name: key, value: "\(value)")
                }
                urlComponents.queryItems = queryItems
                request.url = urlComponents.url
                print("urlComponents.url ---->\n",urlComponents.url)
                
            }
        } else {
            if let parameters = type.body {
                do {
                    let jsonData = try JSONEncoder().encode(parameters)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    print("JSON Body: \(jsonString ?? "nil")")
                    request.httpBody = jsonData
                } catch {
                    print("Error encoding parameters: \(error)")
                }
            }

        }
        
        request.allHTTPHeaderFields = type.headers
        print("API Request ---->\n",request)
        // Network Request - URL TO DATA
        networkHandler.requestDataAPI(url: request) { result in
            switch result {
            case .success(let data):
                // Json parsing - Decoder - DATA TO MODEL
                self.responseHandler.parseResonseDecode(
                    data: data,
                    modelType: modelType) { response in
                        switch response {
                        case .success(let mainResponse):
                            completion(.success(mainResponse)) // Final
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            case .failure(let error):    
                completion(.failure(error))
            }
        }
    }
    
    static var commonHeaders: [String: String] {
        var headers = ["Content-Type": "application/json"]
        if let token = RSOToken.shared.getToken() {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}

// Like banta hai guys

class NetworkHandler {
    
    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, DataError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            print("API Response ---->\n",response)
            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        session.resume()
    }
    
}

class ResponseHandler {
    
    func parseResonseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type,
        completionHandler: ResultHandler<T>
    ) {
        do {
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            
            completionHandler(.success(userResponse))
        }catch {
            print("decoding error=",error)
            completionHandler(.failure(.decoding(error)))
        }
    }
    
}
