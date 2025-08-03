import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableView(with indexPaths: [IndexPath])
    func configureCell(at indexPath: IndexPath, with photo: Photo, dateText: String, isLiked: Bool)
    func showSingleImage(with url: URL)
    func showAuthErrorAlert()
}
