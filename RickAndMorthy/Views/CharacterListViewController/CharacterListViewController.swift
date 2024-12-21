import UIKit

class CharacterListViewController: UIViewController, FilterDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    private let viewModel = CharacterListViewModel(apiService: RickAndMortyAPIService())
    private let refreshControl = UIRefreshControl()
    private let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
    private let logoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupBindings()
        viewModel.fetchCharacters(reset: true)
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        title = "The Rick and Morty API"
        
        searchButton.target = self
        searchButton.action = #selector(searchButtonTapped)
        
        logoutButton.target = self
        logoutButton.action = #selector(logoutButtonTapped)
        
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterCell")
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        viewModel.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.loadingSpinner.stopAnimating()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                self?.refreshControl.endRefreshing()
                self?.loadingSpinner.stopAnimating()
            }
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.loadingSpinner.startAnimating()
                } else {
                    self?.loadingSpinner.stopAnimating()
                }
            }
        }
    }
    
    @objc private func refreshData() {
        viewModel.fetchCharacters(reset: true)
    }
    
    @objc private func searchButtonTapped() {
        let filterVC = FilterViewController(nibName: "FilterViewController", bundle: nil)
        
        filterVC.delegate = self
        filterVC.configure(with: viewModel.appliedFilters ?? FilterOptions())
        
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 20
        }
        
        present(filterVC, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "Sign Out", 
                                    message: "Are you sure you want to sign out?", 
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.viewModel.logout { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.dismiss(animated: true)
                    case .failure(let error):
                        let errorAlert = UIAlertController(title: "Error",
                                                         message: error.localizedDescription,
                                                         preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(errorAlert, animated: true)
                    }
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    func didApplyFilters(_ filters: FilterOptions) {
        viewModel.fetchCharacters(reset: true, filters: filters)
    }
}

extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        let character = viewModel.characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.characters.count - 5 && !viewModel.isLoading && viewModel.hasMorePages {
            viewModel.fetchNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = viewModel.characters[indexPath.row]
        
        let detailsViewModel = CharacterDetailsViewModel(apiService: RickAndMortyAPIService())
        let detailsVC = CharacterDetailsViewController(viewModel: detailsViewModel)
        detailsVC.configure(with: character)
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
