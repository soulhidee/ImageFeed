import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case invalidData
    case tokenMissing
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            let urlString = request.url?.absoluteString ?? "nil"
            
            if let error = error {
                print("[data(for:)]: URLRequestError - \(error.localizedDescription), URL: \(urlString)")
                return fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("[data(for:)]: URLSessionError - неизвестная ошибка, URL: \(urlString)")
                return fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
            }
            
            let statusCode = httpResponse.statusCode
            if (200..<300).contains(statusCode) {
                fulfillCompletionOnMainThread(.success(data))
            } else {
                print("[data(for:)]: HTTPStatusCodeError - код ошибки \(statusCode), URL: \(urlString)")
                fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
            }
        }
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedObject))
                    }
                } catch {
                    print("[objectTask]: DecodingError - \(error.localizedDescription), данные: \(String(data: data, encoding: .utf8) ?? "nil"), URL: \(request.url?.absoluteString ?? "nil")")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("[objectTask]: Failure - \(error.localizedDescription), URL: \(request.url?.absoluteString ?? "nil")")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        return task
    }
}
