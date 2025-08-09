import XCTest
@testable import ImageFeed

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func pasteText(_ text: String, into element: XCUIElement) {
        UIPasteboard.general.string = text
        element.tap()
        element.press(forDuration: 1.1)
        let pasteMenuItem = XCUIApplication().menuItems["Paste"]
        XCTAssertTrue(pasteMenuItem.waitForExistence(timeout: 2), "Кнопка 'Paste' не появилась")
        pasteMenuItem.tap()
    }

    func testAuth() throws {
        let app = XCUIApplication()
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5), "WebView 'UnsplashWebView' не загрузился")
        
        // Вставляем логин
        let loginTextField = webView.textFields.element(boundBy: 0)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5), "Поле для логина не найдено")
        pasteText("Email", into: loginTextField)
        
        webView.tap()
        sleep(1)
        
        let passwordTextField = webView.secureTextFields.element(boundBy: 0)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5), "Поле для пароля не найдено")
        pasteText("Password", into: passwordTextField)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "Экран ленты не загрузился")
    }

    
    func testFeed() throws {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        XCTAssertTrue(tablesQuery.element.waitForExistence(timeout: 5), "Экран ленты не загрузился вовремя")

        let firstCell = tablesQuery.cells.element(boundBy: 0)
        firstCell.swipeUp()

        sleep(2)

        let cellToLike = tablesQuery.cells.element(boundBy: 0)
        let likeButtonOff = cellToLike.buttons["like button off"]
        XCTAssertTrue(likeButtonOff.waitForExistence(timeout: 2), "Кнопка лайка (выкл) не найдена")
        likeButtonOff.tap()

        let likeButtonOn = cellToLike.buttons["like button on"]
        XCTAssertTrue(likeButtonOn.waitForExistence(timeout: 2), "Кнопка лайка (вкл) не найдена")
        likeButtonOn.tap()

        sleep(2)

        cellToLike.tap()

        let imageView = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(imageView.waitForExistence(timeout: 5), "Полноэкранное изображение не загрузилось")

        imageView.pinch(withScale: 3, velocity: 1)

        imageView.pinch(withScale: 0.5, velocity: -1)

        let backButton = app.buttons["nav back button white"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 2), "Кнопка 'назад' не найдена")
        backButton.tap()

        XCTAssertTrue(tablesQuery.element.waitForExistence(timeout: 5), "Не удалось вернуться на экран ленты")
    }
    
    func testProfile() throws {
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["user_name_label"].exists, "Имя пользователя не отображается на экране профиля")

        XCTAssertTrue(app.staticTexts["user_nickname_label"].exists, "Ник пользователя не отображается на экране профиля")

        app.buttons["logout button"].tap()

        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["logout_confirm_button"].tap()
    }
}
