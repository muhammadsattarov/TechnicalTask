


import UIKit

class HomeViewController: UIViewController {

  private let searchController = UISearchController(searchResultsController: nil)

  private let homeTableView = HomeTableView()

  private var filteredTodos: [Todo] = [] // Filtered data

  private let viewModel = HomeViewModel()

  //MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    fetchUserFromDatabase()
    setupNotification()
  }
}

//MARK: - Setup Views
private extension HomeViewController {
  func setupViews() {
    addSubviews()
    setConstraints()
    setupSearchBar()
    fetchDataFromDatabase()
  }
}

//MARK: - Add Subviews
private extension HomeViewController {
  func addSubviews() {
    view.addSubview(homeTableView)
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
    homeTableView.delegate = self
  }
}

//MARK: - Setup SearchBar
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

//MARK: - Add Subviews
private extension HomeViewController {
  func fetchUserFromDatabase() {
    print(#function)
    viewModel.fetchData()
  }

  func fetchDataFromDatabase() {
    viewModel.onDataLoaded = { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.homeTableView.configure(todos: self.viewModel.todos, users: self.viewModel.users)
        self.homeTableView.tableView.reloadData()
      }
    }
  }
}

//MARK: - Constraints
private extension HomeViewController {
  func setConstraints() {
    NSLayoutConstraint.activate([
      homeTableView.topAnchor.constraint(equalTo: view.topAnchor),
      homeTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      homeTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
          homeTableView.isSearching = false
        homeTableView.configure(todos: viewModel.todos, users: viewModel.users)
          return
      }

      homeTableView.isSearching = true

    filteredTodos = viewModel.todos.filter { todo in
      let user = viewModel.users.first(where: { $0.id == todo.userId })
          let userName = user?.name.lowercased() ?? ""
          return todo.title.lowercased().contains(searchText.lowercased()) ||
                 userName.contains(searchText.lowercased())
      }

      var filteredDisplayedTodos: [Int: [Todo]] = [:]
      let groupedTodos = Dictionary(grouping: filteredTodos, by: { $0.userId })
      for (userId, todos) in groupedTodos {
          filteredDisplayedTodos[userId] = Array(todos.prefix(20))
      }

    homeTableView.updateDisplayedTodos(filteredDisplayedTodos)
  }
}

//MARK: - HomeTableViewDelegate
extension HomeViewController: HomeTableViewDelegate {
  func didSelectRowAt(_ indexPath: IndexPath, user: User) {
    let vc = UserInfoViewController()
    vc.configure(with: user)
    navigationController?.pushViewController(vc, animated: true)
  }

  func loadMoreTodos() {
      viewModel.loadMoreTodos()
  }
}


//MARK: - Setup Notification
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
