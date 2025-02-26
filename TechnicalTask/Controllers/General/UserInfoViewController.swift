

import UIKit

class UserInfoViewController: UIViewController {


  private var user: User? {
    didSet {
      print(user)
    }
  }

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
    view.backgroundColor = .yellow
    addSubviews()
    setConstraints()
  }
}

// MARK: - Setup Views
private extension UserInfoViewController {
  func addSubviews() {

  }
}

// MARK: - Setup Views
private extension UserInfoViewController {
  func setConstraints() {
    NSLayoutConstraint.activate([

    ])
  }
}
