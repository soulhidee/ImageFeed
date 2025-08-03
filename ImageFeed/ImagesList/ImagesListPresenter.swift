import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectRow(at indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
    func configureCell(at indexPath: IndexPath)
    func didTapLike(at indexPath: IndexPath)
    func numberOfRows() -> Int
}
