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
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let view = ProfileViewControllerSpy()
        let mockImageService = ProfileImageServiceMock()
        let presenter = ProfilePresenter(profileImageService: mockImageService)
        presenter.view = view
        view.presenter = presenter
        
        // when
        presenter.avatarDidChange()
        
        // then
        XCTAssertTrue(view.updateAvatarCalled, "updateAvatar должен быть вызван у вью после avatarDidChange у презентера")
    }
    
    func testPresenterCallsStopShimmerAnimation() {
        //given
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        presenter.view = view
        view.presenter = presenter
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(view.stopShimmerAnimationCalled, "stopShimmerAnimation должен быть вызван у вью после viewDidLoad у презентера")
    }
    
    func testLogoutButtonShowsAlert() {
            // given
            let viewController = ProfileViewController()
            let presenter = ProfilePresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController

            let window = UIWindow()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            let expectation = XCTestExpectation(description: "Ожидание представления алерта")
            
            // when
            _ = viewController.view
            DispatchQueue.main.async {
                viewController.triggerLogoutButtonTappedForTesting()
                
                // then
                let presentedVC = viewController.presentedViewController
                XCTAssertTrue(presentedVC is UIAlertController, "При нажатии на кнопку logout должен быть показан UIAlertController")
                
                if let alert = presentedVC as? UIAlertController {
                    XCTAssertEqual(alert.title, "Пока, пока!", "Заголовок алерта должен быть 'Пока, пока!'")
                    XCTAssertEqual(alert.message, "Уверены что хотите выйти?", "Сообщение алерта должно быть 'Уверены что хотите выйти?'")
                    XCTAssertEqual(alert.actions.count, 2, "Алерт должен содержать две кнопки")
                    XCTAssertEqual(alert.actions[0].title, "Нет", "Первая кнопка должна быть 'Нет'")
                    XCTAssertEqual(alert.actions[1].title, "Да", "Вторая кнопка должна быть 'Да'")
                } else {
                    XCTFail("Алерт не представлен")
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
        }
        
    override func tearDown() {
        super.tearDown()
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.rootViewController = nil }
    }
}




