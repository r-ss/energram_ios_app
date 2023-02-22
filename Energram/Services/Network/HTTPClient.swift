//
//  HTTPClient.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

/// https://betterprogramming.pub/async-await-generic-network-layer-with-swift-5-5-2bdd51224ea9

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        guard let url = endpoint.urlComponents?.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let header = endpoint.header {
            request.allHTTPHeaderFields = header
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
//        print(request.allHTTPHeaderFields)
//        print(request.httpBody)
        
//        let str = String(decoding: request.httpBody!, as: UTF8.self)
//        print(str)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            //            print(response)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ decoder in
                /// This allows to decode date in 2023-02-17 format, ton only in ISO
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                if let date = formatter.date(from: dateString) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            })
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? decoder.decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                
                /// Here we try to obtain new access token by using refresh_token
                guard let errorDetailDecodedResponse: RequestErrorMessage = try? decoder.decode(RequestErrorMessage.self, from: data) else {
                    return .failure(.unauthorized)
                }
                
                if errorDetailDecodedResponse.detail == "Error decoding token (Signature Expired)" {
                    print("401 - trying to obtain new tokens pair...")
                    let tokens = await UserService().useRefreshToken()
                    switch tokens {
                    case .success(let tokensResult):
//                        print(tokensResult)
                        UserService().saveFreshRefreshTokens(tokens: tokensResult)
                        return await sendRequest(endpoint: endpoint, responseModel: responseModel)
                    case .failure(let tokensError):
                        print("useRefreshToken request failed with error: \(tokensError.customMessage)")
                    }
                /// End of refresh token obtain block
                    
                    
                }

                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}


extension HTTPClient {
    func sendMultipartFormAuthRequest<T: Decodable>(
        endpoint: Endpoint,
        email: String,
        password: String,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        guard let url = endpoint.urlComponents?.url else {
            return .failure(.invalidURL)
        }
        
//        let url = URL(string: "http://127.0.0.1:8000/token")!

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

//        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        //request.httpMethod = endpoint.method.rawValue
        request.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=X-\(boundary)-BOUNDARY", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("--X-\(boundary)-BOUNDARY\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n\(email)\r\n".data(using: .utf8)!)
        data.append("--X-\(boundary)-BOUNDARY\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n\(password)\r\n".data(using: .utf8)!)
        data.append("--X-\(boundary)-BOUNDARY--".data(using: .utf8)!)
        
//        let str = String(decoding: data, as: UTF8.self)
//        print(str)
        
        request.httpBody = data as Data
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
//            print(response)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ decoder in
                /// This allows to decode date in 2023-02-17 format, ton only in ISO
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                if let date = formatter.date(from: dateString) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            })

            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? decoder.decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}


extension HTTPClient {
    func getPrettyPrintedJSONResponse(endpoint: Endpoint) async -> Result<String, RequestError> {
        
        guard let url = endpoint.urlComponents?.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        //        print(url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            //            print(response)
            
            switch response.statusCode {
            case 200...299:
                return .success(data.prettyPrintedJSONString!)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
