


import UIKit

class HomeViewController: UIViewController {

private let homeTableView = HomeTableView()

  //MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    fetchDataFromDatabase()
    fetchUserFromDatabase()
  }
}

//MARK: - Setup Views
private extension HomeViewController {
  func setupViews() {
    addSubviews()
    setConstraints()
  }
}

//MARK: - Add Subviews
private extension HomeViewController {
  func addSubviews() {
    view.addSubview(homeTableView)
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
  }
}

//MARK: - Add Subviews
private extension HomeViewController {
  func fetchDataFromDatabase() {
    TodoService.shared.fetchTodos { [weak self] todos in
      guard let self = self else { return }
      if let todos {
        self.homeTableView.configure(with: todos)
      }
    }
  }

  func fetchUserFromDatabase() {
    TodoService.shared.fetchUsers { users in
      if let users {
        self.homeTableView.configure(users)
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
