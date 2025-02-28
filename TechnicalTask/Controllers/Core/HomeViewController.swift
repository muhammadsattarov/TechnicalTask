


import UIKit


class HomeViewController: UIViewController {

  private let searchController = UISearchController(searchResultsController: nil)
  private let homeTableView = HomeTableView()
  private let viewModel = HomeViewModel()

  private var filteredDisplayedTodos: [Int: [Todo]] = [:]
  private var isSearching: Bool = false

  // MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupSearchBar()
    setupNotification()
    fetchData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }
}

// MARK: - Setup Views
private extension HomeViewController {
  func setupViews() {
    view.addSubview(homeTableView)
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
    homeTableView.delegate = self

    NSLayoutConstraint.activate([
      homeTableView.topAnchor.constraint(equalTo: view.topAnchor),
      homeTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      homeTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Setup SearchBar
private extension HomeViewController {
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search..."
    navigationItem.searchController = searchController
    definesPresentationContext = true
    navigationController?.navigationBar.tintColor = .black
    searchController.hidesNavigationBarDuringPresentation = false
  }
}

// MARK: - Fetching Data
private extension HomeViewController {
  func fetchData() {
    viewModel.onDataLoaded = { [weak self] users, displayedTodos in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.homeTableView.configure(todos: displayedTodos, users: users)
        self.homeTableView.updateDisplayedTodos(displayedTodos)
      }
    }
    viewModel.fetchData()
  }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
      isSearching = false
      homeTableView.isSearching = false
      homeTableView.updateDisplayedTodos(viewModel.displayedTodos)
      return
    }

    isSearching = true
    homeTableView.isSearching = true

    let filteredTodos = viewModel.allTodos.filter { todo in
      let user = viewModel.users.first(where: { $0.id == todo.userId })
      let userName = user?.name.lowercased() ?? ""
      return todo.title.lowercased().contains(searchText.lowercased()) ||
      userName.contains(searchText.lowercased())
    }

    filteredDisplayedTodos = Dictionary(grouping: filteredTodos, by: { $0.userId })
    homeTableView.updateDisplayedTodos(filteredDisplayedTodos)
  }
}

// MARK: - HomeTableViewDelegate
extension HomeViewController: HomeTableViewDelegate {
  var isLoadingMore: Bool {
    get { viewModel.isLoadingMore }
    set { viewModel.isLoadingMore = newValue }
  }

  var hasMoreData: Bool {
    return viewModel.hasMoreData
  }

  func didSelectRowAt(_ indexPath: IndexPath, user: User) {
    let vc = UserInfoViewController()
    vc.configure(with: user)
    navigationController?.pushViewController(vc, animated: true)
  }

  func loadMoreTodos() {
    guard !isLoadingMore, hasMoreData else { return }

    isLoadingMore = true
    viewModel.loadMoreTodos()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      guard let self = self else { return }
      self.isLoadingMore = false
      self.homeTableView.updateDisplayedTodos(self.viewModel.displayedTodos)
    }
  }
}

// MARK: - Setup Notification
private extension HomeViewController {
  func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .networkStatusChanged, object: nil)
  }

  @objc private func networkStatusChanged(_ notification: Notification) {
    if let isConnected = notification.object as? Bool {
      print("Tarmoq holati o‘zgardi: \(isConnected ? "Online" : "Offline")")
    }
  }
}
