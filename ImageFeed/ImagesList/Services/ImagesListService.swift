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
    
    }
    
}
