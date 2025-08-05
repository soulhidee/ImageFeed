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
}
