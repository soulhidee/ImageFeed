import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private(set) var photos: [Photo] = []
    private let perPage = 10
    private let session = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    
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
    
    private func makeURL(page: Int) -> URL? {
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        return components?.url
    }
}
