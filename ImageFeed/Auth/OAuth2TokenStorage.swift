import Foundation

final class OAuth2TokenStorage {
    private let key = "BearerToken"
    private let userDefaults = UserDefaults.standard
    
    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: key)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: key)
    }
}
