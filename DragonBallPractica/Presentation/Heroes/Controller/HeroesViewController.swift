import UIKit

final class HeroesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Properties
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.title
        initViews()
        setObservers()
        viewModel?.onViewsLoaded()
    }
}

private extension HeroesViewController {
    enum Constants {
        static let heightRow: CGFloat = 300.0
    }
}

private extension HeroesViewController {
    func initViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let heroCellNib = UINib(nibName: "\(HeroCell.self)", bundle: nil)
        tableView.register(heroCellNib, forCellReuseIdentifier: HeroCell.reuseIdentifier)
    }
    
    func setObservers() {
        viewModel?.viewState = { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                switch state {
                case let .loading(isLoading):
                    self.loadingView.isHidden = !isLoading
                case .updateData:
                    self.tableView.reloadData()
                case .navigateToHeroDetail:
                    break
                }
            }
        }
    }
}

extension HeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.onItemSelected(at: indexPath.row)
    }
}

extension HeroesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.dataCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseIdentifier, for: indexPath) as? HeroCell else {
            return UITableViewCell()
        }
        
        if let heroCellModel = viewModel?.heroCellModel(at: indexPath.row) {
            cell.updateViews(model: heroCellModel)
        }
        
        return cell
    }
}
