@testable import ImageFeed
import XCTest

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    var lastCompletion: ((Result<Void, Error>) -> Void)?
    var lastPage: Int?
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
        photos = [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                welcomeDescription: "Test Photo",
                thumbImageURL: "https://example.com/thumb.jpg",
                largeImageURL: "https://example.com/large.jpg",
                isLiked: false
            )
        ]
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
        lastCompletion = completion
        
        photos = photos.map { photo in
            if photo.id == photoId {
                return Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: isLike
                )
            }
            return photo
        }
        
        // Отправляем уведомление, как в оригинальном ImagesListService
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: nil,
            userInfo: [ImagesListService.serviceConstants.UserInfoKey.photos: photos]
        )
        
        completion(.success(()))
    }
    
    func reset() {
        photos = []
        fetchPhotosNextPageCalled = false
        changeLikeCalled = false
        lastCompletion = nil
        lastPage = nil
    }
    
    func makeURL(page: Int) -> URL? {
        lastPage = page
        return URL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=10")
    }
}
