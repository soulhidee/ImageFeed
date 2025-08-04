import Foundation
import UIKit

protocol ImagesListViewProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func insertNewRows(from oldCount: Int, to newCount: Int)
    func updateTableViewAnimated()
    func reloadCell(at indexPath: IndexPath)
    func showLikeError(message: String)
    func showProgressHUD()
    func dismissProgressHUD()
    func showSingleImage(with url: URL)
}
