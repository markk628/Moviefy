//
//  APIClient.swift
//  Moviefy
//
//  Created by Mark Kim on 7/7/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct APIClient {
    static let shared = APIClient()
    let session = URLSession(configuration: .default)
    let parameters = [
        "sort_by": "popularity.desc"
    ]
    
    func getPopularMovies(_ completion: @escaping (Result<[Movie]>) -> ()) {
        do {
            let request = try Request.configureRequest(from: .movies, with: parameters, and: .get, contains: nil)
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse, let data = data {
                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(MovieApiResponse.self, from: data)
                        completion(Result.success(result!.movies))
                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        } catch {
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func createRequestToken(_ completion: @escaping (Result<AuthenticationTokenResponse>) -> ()) {
        do {
            let request = try Request.configureRequest(from: .token, with: [:], and: .get, contains: nil)
            session.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse, let data = data {
                    /*do {
                        let resultObject = try JSONSerialization.jsonObject(with: data, options: [])
                        DispatchQueue.main.async(execute: {
                            print("Results from POST request:\n\(resultObject)")
                        })
                    } catch {
                        DispatchQueue.main.async(execute: {
                            print("Unable to parse JSON response")
                        })
                    }*/
                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(AuthenticationTokenResponse.self, from: data)
                        completion(Result.success(result!))
                        print(result)
                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        } catch {
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func createSession(requestToken: String, _ completion: @escaping (Result<CreateSessionResponse>) -> Void) {
        do {
            let request = try Request.configureRequest(from: .session, with: ["request_token": requestToken], and: .get, contains: nil)
            session.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse, let data = data {
                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(CreateSessionResponse.self, from: data)
                        completion(Result.success(result!))
                        print(result)
                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        } catch {
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func getAccountInfo(sessionId: String, _ completion: @escaping (Result<Account>) -> Void) {
        do {
            let request = try Request.configureRequest(from: .session, with: ["session_id": sessionId], and: .get, contains: nil)
            session.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse, let data = data {
                    do {
                        let resultObject = try JSONSerialization.jsonObject(with: data, options: [])
                        DispatchQueue.main.async(execute: {
                            print("Results from POST request:\n\(resultObject)")
                        })
                    } catch {
                        DispatchQueue.main.async(execute: {
                            print("Unable to parse JSON response")
                        })
                    }
//                    let result = Response.handleResponse(for: response)
//                    switch result {
//                    case .success:
//                        let result = try? JSONDecoder().decode(Account.self, from: data)
//                        completion(Result.success(result!))
//                        print(result)
//                    case .failure:
//                        completion(Result.failure(NetworkError.decodingFailed))
//                    }
                }
            }.resume()
        } catch {
            completion(Result.failure(NetworkError.badRequest))
        }
    }
}
