import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    private func logout() {
        cleanCookies()
        OAuth2TokenStorage().token = nil
        ProfileService.shared.reset()
        ProfileImageService.shared.reset()
        ImagesListService.shared.reset()
        
        DispatchQueue.main.async {
             guard let windowScene = UIApplication.shared.connectedScenes
                     .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                   let window = windowScene.windows.first else {
                 print("[ProfileLogoutService]: Не удалось получить windowScene/window")
                 return
             }

             let splashVC = SplashViewController()
             let navVC = UINavigationController(rootViewController: splashVC)
             window.rootViewController = navVC
             window.makeKeyAndVisible()
         }
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
