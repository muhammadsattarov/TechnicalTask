

import UIKit


class HomeTableView: UIView {

  private let tableView: UITableView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(HomeTableViewCell.self,
                forCellReuseIdentifier: HomeTableViewCell.reuseId)
    return $0
  }(UITableView(frame: .zero, style: .grouped))

  var todos: [Todo] = []
  var users: [User] = []

  weak var delegate: HomeTableViewDelegate?

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  func configure(with model: [Todo]) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.todos = model
      self.tableView.reloadData()
    }
  }

  func configure(_ users: [User]) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.users = users
      self.tableView.reloadData()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup UI
private extension HomeTableView {
  func setupUI() {
    self.backgroundColor = .white
    self.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    setConstraints()
  }
}

// MARK: - Constraints
private extension HomeTableView {
  func setConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: self.topAnchor),
      tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeTableView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseId, for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    let todo = todos[indexPath.row]
    guard let user = getUserData(for: todo.userId) else { return UITableViewCell() }
    cell.configure(user.name, description: todo.title)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let todo = todos[indexPath.row]
    guard let user = getUserData(for: todo.userId) else { return }
    delegate?.didSelectRowAt(indexPath, user: user)
  }
}

// MARK: - Get userdata
extension HomeTableView {
  func getUserData(for userId: Int) -> User? {
    return users.first(where: { $0.id == userId })
  }
}
