


import UIKit

class HomeViewController: UIViewController {

  private let searchController = UISearchController(searchResultsController: nil)

  private let homeTableView = HomeTableView()

  private var todos: [Todo] = []
  private var users: [User] = []
  private var filteredTodos: [Todo] = [] // 🔹 Filterlangan ma’lumotlar

  //MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    fetchUserFromDatabase()
    fetchDataFromDatabase()
  }
}

//MARK: - Setup Views
private extension HomeViewController {
  func setupViews() {
    addSubviews()
    setConstraints()
    setupSearchBar()
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
    TodoService.shared.fetchUsers { users in
      if let users {
        self.users = users
        self.homeTableView.configure(self.users)
      }
    }
  }

  func fetchDataFromDatabase() {
    TodoService.shared.fetchTodos { [weak self] todos in
      guard let self = self else { return }
      if let todos {
        self.todos = todos
        self.homeTableView.configure(with: self.todos)
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
            filteredTodos = todos // 🔹 Agar qidiruv bo‘lmasa, barcha ma’lumotlarni ko‘rsatamiz
            homeTableView.configure(with: filteredTodos)
            return
        }
      print(searchText)

        filteredTodos = todos.filter { todo in
            let user = users.first(where: { $0.id == todo.userId })
            let userName = user?.name.lowercased() ?? ""
            return todo.title.lowercased().contains(searchText.lowercased()) ||
                   userName.contains(searchText.lowercased())
        }
        homeTableView.configure(with: filteredTodos)
    }
}

//MARK: - HomeTableViewDelegate
extension HomeViewController: HomeTableViewDelegate {
  func didSelectRowAt(_ indexPath: IndexPath, user: User) {
    let vc = UserInfoViewController()
    vc.configure(with: user)
    navigationController?.pushViewController(vc, animated: true)
  }
}

