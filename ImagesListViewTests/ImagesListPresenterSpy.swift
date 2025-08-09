@testable import ImageFeed
import XCTest

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewProtocol?
    var viewDidLoadCalled = false
    var photos: [Photo] = []
    
    var photosCount: Int {
        photos.count
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
    
    func sizeForPhoto(at index: Int) -> CGSize {
        CGSize(width: 100, height: 100)
    }
    
    func configCell(_ cell: ImagesListCell, for index: Int) {}
    
    func didSelectImage(at index: Int) {}
    
    func didTapLike(at index: Int) {}
}
