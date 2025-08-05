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
}
