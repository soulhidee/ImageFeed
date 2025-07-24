import Foundation

final class ImagesListService {
    //MARK: - Constants
    enum serviceConstants {
        enum API {
            static let baseURL = "https://api.unsplash.com"
            static let photosPath = "/photos"
            static let likePathSuffix = "/like"
            static let pageQueryKey = "page"
            static let perPageQueryKey = "per_page"
            static let perPage = 10
            static let pageIncrement = 1
            static func likePhotoURL(photoId: String) -> URL? {
                URL(string: "\(baseURL)\(photosPath)/\(photoId)\(likePathSuffix)")
            }
        }
        
        enum HTTPHeader {
            static let authorization = "Authorization"
            static let bearerPrefix = "Bearer"
        }
        
        enum NotificationName {
            static let imagesListDidChange = Notification.Name("ImagesListServiceDidChange")
        }
        
        enum UserInfoKey {
            static let photos = "photos"
        }
    }
    
    // MARK: - Notifications
    static let didChangeNotification = serviceConstants.NotificationName.imagesListDidChange
    
    // MARK: - Private properties
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private let perPage = serviceConstants.API.perPage
    private let session = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Public properties
    private(set) var photos: [Photo] = []
    
    // MARK: - Singleton
    static let shared = ImagesListService()
    
    private init() {}
    
    // MARK: - Public methods
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        guard let token = tokenStorage.token else {
            print("[ImagesListService]: Токен отсутствует")
            return
        }
        
        let nextPage = (lastLoadedPage ?? .zero) + serviceConstants.API.pageIncrement
        
        guard let url = makeURL(page: nextPage) else {
            print("[ImagesListService]: Некорректный URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("\(serviceConstants.HTTPHeader.bearerPrefix) \(token)", forHTTPHeaderField: serviceConstants.HTTPHeader.authorization)
        
        task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            self.task = nil
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { Photo(from: $0) }
                self.lastLoadedPage = nextPage
                self.photos.append(contentsOf: newPhotos)
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: [serviceConstants.API.photosPath: self.photos]
                )
            case .failure(let error):
                print("[ImagesListService]: Ошибка загрузки — \(error.localizedDescription)")
            }
        }
        
        task?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            print("[ImagesListService]: Токен отсутствует")
            return
        }
        
        guard let url = serviceConstants.API.likePhotoURL(photoId: photoId) else {
            print("[ImagesListService]: Некорректный URL для лайка")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        
        request.setValue(
            "\(serviceConstants.HTTPHeader.bearerPrefix) \(token)",
            forHTTPHeaderField: serviceConstants.HTTPHeader.authorization
        )
        
        let task = session.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                        
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: [serviceConstants.UserInfoKey.photos: self.photos]
                        )
                    }
                    completion(.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeURL(page: Int) -> URL? {
        var components = URLComponents(string: serviceConstants.API.baseURL + serviceConstants.API.photosPath)
        components?.queryItems = [
            URLQueryItem(name: serviceConstants.API.pageQueryKey, value: "\(page)"),
            URLQueryItem(name: serviceConstants.API.perPageQueryKey, value: "\(perPage)")
        ]
        return components?.url
    }
    
    // MARK: - Reset
    func reset() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
}
