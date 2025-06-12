import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithToken token: String)
}
