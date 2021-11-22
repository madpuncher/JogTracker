import Foundation

protocol NetworkServiceProtocol {
    func postRequestToLogin(uuid: String,
                            completion: @escaping (Result<AuthResponseTokens, Error>) -> Void)
    
    func getRequestForJogs(accessToken: String,
                           tokenType: String,
                           completion: @escaping (Result<[SomeJog], Error>) -> Void)
    
    func postNewJogRequest(accessToken: String,
                           tokenType: String,
                           distance: String,
                           time: String,
                           date: String,
                           completion: @escaping (Bool) -> Void)
    
    func putChangeJogRequest(accessToken: String,
                             id: String,
                             userId: String,
                             tokenType: String,
                             distance: String,
                             time: String,
                             date: String,
                             completion: @escaping (Bool) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    ///Requst for login
    public func postRequestToLogin(uuid: String = "hello", completion: @escaping (Result<AuthResponseTokens, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: ApiContants.loginPath)
        
        urlComponents?.queryItems = [URLQueryItem(name: "uuid", value: uuid)]
        
        guard let finalURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = .postMethod
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    return
                }
            
            do {
                let loginResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                completion(.success(loginResponse.response))
            } catch  {
                completion(.failure(ErrorType.failedToLogin))
            }
            
        }
        .resume()
    }
    
    ///Requst for jogs
    public func getRequestForJogs(accessToken: String,
                                  tokenType: String,
                                  completion: @escaping (Result<[SomeJog], Error>) -> Void) {
        
        var urlComponents = URLComponents(string: ApiContants.jogsPath)
        
        urlComponents?.queryItems = [URLQueryItem(name: "access_token", value: accessToken),
                                     URLQueryItem(name: "token_type", value: tokenType)
        ]
        
        guard let finalURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = .getMethod
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    return
                }
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data,
                                                                    options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                let responseKeyJson = jsonResponse?["response"] as? [String: Any]
                let jogsResponseKeys = responseKeyJson?["jogs"] as? [[String: Any]]
                
                var decodeItems: [SomeJog] = []
                
                guard let jogs = jogsResponseKeys else {
                    completion(.failure(ErrorType.failedToGetJogs))
                    return
                }
                
                for jog in jogs {
                    
                    if let id = jog["id"] as? Int, let userId = jog["user_id"] as? String, let distance = jog["distance"] as? Int,
                       let date = jog["date"] as? Int,
                       let time = jog["time"] as? Int {
                        decodeItems.append(SomeJog(id: id, userId: userId, distance: distance, time: time, date: date))
                        
                    }
                }
                
                completion(.success(decodeItems))
                
            } catch  {
                completion(.failure(ErrorType.failedToGetJogs))
            }
            
        }
        .resume()
    }
    
    public func postNewJogRequest(accessToken: String,
                                  tokenType: String,
                                  distance: String,
                                  time: String,
                                  date: String,
                                  completion: @escaping (Bool) -> Void) {
                
        var urlComponents = URLComponents(string: ApiContants.newJog)
        
        urlComponents?.queryItems = [URLQueryItem(name: "date", value: date),
                                     URLQueryItem(name: "time", value: time),
                                     URLQueryItem(name: "distance", value: distance)
        ]
        
        guard let finalURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = .postMethod
        request.setValue("\(tokenType) \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let _ = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    completion(false)
                    return
                }
            completion(true)
        }
        .resume()
    }
    
    public func putChangeJogRequest(accessToken: String,
                                    id: String,
                                    userId: String,
                                    tokenType: String,
                                    distance: String,
                                    time: String,
                                    date: String,
                                    completion: @escaping (Bool) -> Void) {
        
        var urlComponents = URLComponents(string: ApiContants.newJog)
        
        urlComponents?.queryItems = [URLQueryItem(name: "jog_id", value: id),
                                     URLQueryItem(name: "user_id", value: userId),
                                     URLQueryItem(name: "distance", value: distance),
                                     URLQueryItem(name: "time", value: time),
                                     URLQueryItem(name: "date", value: date)
        ]
        
        guard let finalURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = .putMethod
        request.setValue("\(tokenType) \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let _ = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    completion(false)
                    return
                }
                completion(true)
        }
        .resume()
    }
    
}

