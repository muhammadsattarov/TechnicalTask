

import UIKit

class HomeTableViewCell: UITableViewCell {
  static let reuseId = "HomeTableViewCell"

  private let titleLabel: UILabel = {
    $0.font = .systemFont(ofSize: 16, weight: .medium)
    $0.textColor = .black
    return $0
  }(UILabel())

  private let descriptionLabel: UILabel = {
    $0.font = .systemFont(ofSize: 14, weight: .regular)
    $0.textColor = .black
    $0.numberOfLines = 0
    return $0
  }(UILabel())

  private lazy var vStack: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.spacing = 5
    return $0
  }(UIStackView(arrangedSubviews: [titleLabel, descriptionLabel]))

  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    setConstraints()
  }

  func configure(_ title: String, description: String) {
    self.titleLabel.text = title
    self.descriptionLabel.text = description
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    descriptionLabel.text = nil
  }
}

// MARK: - Setup UI
private extension HomeTableViewCell {
  func setupUI() {
    self.backgroundColor = .clear
    contentView.addSubview(vStack)
  }
}

// MARK: - Constraints
private extension HomeTableViewCell {
  func setConstraints() {
    let verticalSpace: CGFloat = 10
    let horizontalSpace: CGFloat = 20
    NSLayoutConstraint.activate([
      vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalSpace),
      vStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: horizontalSpace),
      vStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -horizontalSpace),
      vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalSpace),
    ])
  }
}
