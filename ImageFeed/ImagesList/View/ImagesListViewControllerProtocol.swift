import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated()
    func reloadCell(at indexPath: IndexPath)
    func showLikeError(message: String)
}
