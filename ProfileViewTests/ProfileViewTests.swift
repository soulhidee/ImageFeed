@testable import ImageFeed
import XCTest

final class ProfileViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled, "viewDidLoad() у презентера должен быть вызван")
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        // given
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        presenter.view = view
        view.presenter = presenter
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssert(view.updateProfileDetailsCalled, "updateProfileDetails должен быть вызван у вью после viewDidLoad у презентера")
    }
}




