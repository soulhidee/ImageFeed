@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ImagesListService.shared.reset()
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(ImagesListPresenter.self)
        super.tearDown()
    }
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled, "viewDidLoad() у презентера должен быть вызван")
    }
    
    func testPresenterInsertsNewRowsOnPhotosUpdate() {
        // given
        let service = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: service)
        let view = ImagesListViewControllerSpy()
        presenter.view = view
        
        // when
        service.fetchPhotosNextPage()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
        
        // then
        XCTAssertTrue(view.insertNewRowsCalled, "insertNewRows должен быть вызван при обновлении списка фотографий")
    }
    
    func testDidTapLikeShowsProgressHUD() {
        // given
        let service = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: service)
        let view = ImagesListViewControllerSpy()
        presenter.view = view
        presenter.photos = [
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
        
        // when
        presenter.didTapLike(at: 0)
        
        // then
        XCTAssertTrue(view.showProgressHUDCalled, "showProgressHUD должен быть вызван при нажатии на лайк")
    }
    
    func testImagesListServiceMakeURL() {
            // given
            let service = ImagesListServiceMock()
            let page = 1
            
            // when
            let url = service.makeURL(page: page)
            
            // then
            XCTAssertEqual(url?.absoluteString, "https://api.unsplash.com/photos?page=1&per_page=10", "makeURL должен формировать корректный URL")
            XCTAssertEqual(service.lastPage, page, "makeURL должен сохранить правильный номер страницы")
        }
    
    func testImagesListServiceLikePhotoURL() {
            // given
            let photoId = "test_id"
            
            // when
            let url = ImagesListService.serviceConstants.API.likePhotoURL(photoId: photoId)
            
            // then
            XCTAssertEqual(url?.absoluteString, "https://api.unsplash.com/photos/test_id/like", "likePhotoURL должен формировать корректный URL для лайка")
        }
    
    func testPhotosCountMatchesPresenterPhotos() {
            // given
            let presenter = ImagesListPresenterSpy()
            presenter.photos = [
                Photo(id: "1", size: .zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false),
                Photo(id: "2", size: .zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false)
            ]
            
            // then
            XCTAssertEqual(presenter.photosCount, 2, "Количество фотографий должно быть 2")
        }
    
    
}
