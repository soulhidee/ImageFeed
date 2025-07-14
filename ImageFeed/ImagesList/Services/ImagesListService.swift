import Foundation

final class ImagesListService {
    
    // MARK: - Notifications
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    // MARK: - Private properties
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private let perPage = 10
    private let session = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Public properties
    private(set) var photos: [Photo] = []
    
    // MARK: - Public methods
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        guard let token = tokenStorage.token else {
            print("[ImagesListService]: Токен отсутствует")
            return
        }
        
        let nextPage = (lastLoadedPage ?? .zero) + 1
        
        guard let url = makeURL(page: nextPage) else {
            print("[ImagesListService]: Некорректный URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { Photo(from: $0) }
                self.lastLoadedPage = nextPage
                self.photos.append(contentsOf: newPhotos)
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": self.photos]
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
        
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            print("[ImagesListService]: Некорректный URL для лайка")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.data(for: request) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                DispatchQueue.main.async {
                    // Поиск фото по id
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
                            userInfo: ["photos": self.photos]
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
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        return components?.url
    }
}
