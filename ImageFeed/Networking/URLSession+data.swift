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
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    fulfillCompletionOnMainThread(.success(data))
                } else {
                    print("[data(for:)]: HTTPStatusCodeError - код ошибки \(statusCode), URL: \(request.url?.absoluteString ?? "nil")")
                    fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[data(for:)]: URLRequestError - \(error.localizedDescription), URL: \(request.url?.absoluteString ?? "nil")")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[data(for:)]: URLSessionError - неизвестная ошибка, URL: \(request.url?.absoluteString ?? "nil")")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
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
