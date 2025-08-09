@testable import ImageFeed
import XCTest

final class ImagesListViewControllerSpy: ImagesListViewProtocol {
    var presenter: ImagesListPresenterProtocol?
    var insertNewRowsCalled = false
    var updateTableViewAnimatedCalled = false
    var reloadCellCalled = false
    var showLikeErrorCalled = false
    var showProgressHUDCalled = false
    var dismissProgressHUDCalled = false
    var showSingleImageCalled = false
    var lastIndexPath: IndexPath?
    
    func insertNewRows(from oldCount: Int, to newCount: Int) {
        insertNewRowsCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func reloadCell(at indexPath: IndexPath) {
        reloadCellCalled = true
        lastIndexPath = indexPath
    }
    
    func showLikeError(message: String) {
        showLikeErrorCalled = true
    }
    
    func showProgressHUD() {
        showProgressHUDCalled = true
    }
    
    func dismissProgressHUD() {
        dismissProgressHUDCalled = true
    }
    
    func showSingleImage(with url: URL) {
        showSingleImageCalled = true
    }
}
