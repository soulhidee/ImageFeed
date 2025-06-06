import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Создаём UIWindow с текущей сценой
        let window = UIWindow(windowScene: windowScene)

        // Создаём стартовый контроллер
        let authViewController = AuthViewController()
        let navigationController = UINavigationController(rootViewController: authViewController)

        // Устанавливаем rootViewController и делаем окно видимым
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
