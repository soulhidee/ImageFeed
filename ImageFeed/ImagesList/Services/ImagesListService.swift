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
        
        guard let url = makeURL(page: nextPage) else { return }
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
