@testable import ImageFeed
import XCTest

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    weak var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }

    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled, "viewDidLoad() у презентера должен быть вызван")
    }
}

