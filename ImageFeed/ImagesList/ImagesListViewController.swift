import UIKit

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt idexPath: IndexPath) {
        
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Не удалось привести ячейку к типу ImagesListCell на indexPath: \(indexPath)")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell)
        return imageListCell
    }
    
    
}


final class ImagesListViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        tableView.rowHeight = 200
    }
    
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "UIBlack")
        
    }
    
    func configCell(for: ImagesListCell) { }
    
}
