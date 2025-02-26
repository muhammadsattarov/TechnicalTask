
import UIKit

class SearchResultController: UIViewController {
  // MARK: - Properties
  private let homeTableView = HomeTableView()

  // MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  func updateResults(_ users: [User]) {
    homeTableView.configure(users)
  }
}

// MARK: - Setup View
private extension SearchResultController {
  func setupViews() {
    view.backgroundColor = .systemBackground
    addSubviews()
    setConstrains()
  }
}

// MARK: - Add Subviews
private extension SearchResultController {
  func addSubviews() {
    view.addSubview(homeTableView)
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - Constraints
private extension SearchResultController {
  func setConstrains() {
    NSLayoutConstraint.activate([
      homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      homeTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      homeTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}


/*
class SearchResultController: UIViewController {
  // MARK: - Properties
  lazy var tableView: UITableView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(HomeTableViewCell.self,
                forCellReuseIdentifier: HomeTableViewCell.reuseId)
    $0.backgroundColor = .systemBackground
    return $0
  }(UITableView(frame: .zero, style: .plain))

  var filteredData: [Todo] = []
  var userData: [User] = []
  
  // MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setConstrains()
  }

  func updateResults(with items: [Todo]) {
    filteredData = items
    tableView.reloadData()
  }
}

// MARK: - Setup View
private extension SearchResultController {
  func setupViews() {
    view.backgroundColor = .systemBackground
    addSubviews()
    setupTableView()
  }
}

// MARK: -
private extension SearchResultController {
  func addSubviews() {
    view.addSubview(tableView)
  }

  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
}

// MARK: - Setup Keyboard
private extension SearchResultController {
  func setConstrains() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
    ])
  }
}

extension SearchResultController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseId, for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    cell.selectionStyle = .none
    let todo = filteredData[indexPath.row]
    guard let user = getUserData(for: todo.userId) else { return UITableViewCell() }
    cell.configure(user.name, description: todo.title)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UserInfoViewController()
    let product = filteredData[indexPath.row]
   // vc.configure(with: product)
    present(vc, animated: true)
    print("222")
  }
}

extension SearchResultController {
  func getUserData(for userId: Int) -> User? {
    return userData.first(where: { $0.id == userId })
  }
}
*/
