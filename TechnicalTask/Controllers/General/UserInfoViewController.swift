

import UIKit

class UserInfoViewController: UIViewController {
  // MARK: - UI Components
  private let scrollView = UIScrollView()
  private let contentView = UIView()

  private let stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.spacing = 10
      stackView.alignment = .leading
      return stackView
  }()

  private var user: User?

  // MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  func configure(with model: User) {
    self.user = model
  }
}

// MARK: - Setup Views
private extension UserInfoViewController {
  func setupViews() {
    view.backgroundColor = .white
    addSubviews()
    setConstraints()
    configureUI()
  }
}

// MARK: - Add Subviews
private extension UserInfoViewController {
  func addSubviews() {
    view.addSubview(scrollView)
    scrollView.alwaysBounceVertical = true
    scrollView.addSubview(contentView)
    contentView.addSubview(stackView)

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - Constraints
private extension UserInfoViewController {
  func setConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
      contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
      stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
    ])
  }
}

private extension UserInfoViewController {
  private func configureUI() {
      guard let user = user else { return }
    navigationItem.title = user.name
      let nameLabel = createLabel(text: "👤 Name: \(user.name)")
      let usernameLabel = createLabel(text: "📛 Username: \(user.username)")
      let emailLabel = createLabel(text: "📧 Email: \(user.email)")
      let phoneLabel = createLabel(text: "📞 Phone: \(user.phone)")
      let websiteLabel = createLabel(text: "🌐 Website: \(user.website)")
      let companyLabel = createLabel(text: "🏢 Company: \(user.company.name)")

      let addressLabel = createLabel(text: """
      📍 Address:
      \(user.address.street), \(user.address.suite),
      \(user.address.city) - \(user.address.zipcode)
      """)

      // 🔹 Hammasini stackView'ga qo‘shish
      [nameLabel, usernameLabel, emailLabel, phoneLabel, websiteLabel, companyLabel, addressLabel].forEach { stackView.addArrangedSubview($0) }
  }

  private func createLabel(text: String) -> UILabel {
      let label = UILabel()
      label.text = text
      label.font = .systemFont(ofSize: 16, weight: .regular)
      label.numberOfLines = 0
      return label
  }
}
