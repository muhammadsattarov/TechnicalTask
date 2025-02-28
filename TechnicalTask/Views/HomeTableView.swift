

import UIKit


class HomeTableView: UIView {

    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(HomeTableViewCell.self,
                    forCellReuseIdentifier: HomeTableViewCell.reuseId)
        return $0
    }(UITableView(frame: .zero, style: .plain))

    var displayedTodos: [Int: [Todo]] = [:] // ViewModel orqali keladi
    var users: [User] = []
    var isSearching: Bool = false

    weak var delegate: HomeTableViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    func configure(todos: [Int: [Todo]], users: [User]) {
        self.users = users
        self.displayedTodos = todos
        tableView.reloadData()
    }

  func updateDisplayedTodos(_ newDisplayedTodos: [Int: [Todo]]) {
    self.displayedTodos = newDisplayedTodos
    tableView.reloadData()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userId = users[section].id
        return displayedTodos[userId]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseId, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        let userId = users[indexPath.section].id
        if let todo = displayedTodos[userId]?[indexPath.row] {
            guard let user = getUserData(for: todo.userId) else { return UITableViewCell() }
            cell.configure(user.name, description: todo.title)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearching ? nil : users[section].name
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = users[indexPath.section].id
        guard let todo = displayedTodos[userId]?[indexPath.row],
              let user = getUserData(for: todo.userId) else { return }
        delegate?.didSelectRowAt(indexPath, user: user)
    }
}

// MARK: - Get userdata
extension HomeTableView {
    func getUserData(for userId: Int) -> User? {
        return users.first(where: { $0.id == userId })
    }
}

// MARK: - UIScrollViewDelegate (pagination uchun)
extension HomeTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        guard let delegate = delegate, !delegate.isLoadingMore, delegate.hasMoreData else { return }

        if offsetY > (contentHeight - scrollViewHeight - 50) {
            delegate.loadMoreTodos()
        }
    }
}
