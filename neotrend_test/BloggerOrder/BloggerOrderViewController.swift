import UIKit

class BloggerOrderViewController: UIViewController {
  private let containerView = UIView()
  private let closeButton = UIButton(type: .system)
  private let titleLabel = UILabel()
  
  private let contentBackgroundView = UIView()
  private let bloggerLabel = UILabel()
  private let bloggerUsernameLabel = UILabel()
  private let separator1 = UIView()
  private let ratingLabel = UILabel()
  private let ratingStarsView = UIStackView()
  private let separator2 = UIView()
  private let priceLabel = UILabel()
  private let priceValueLabel = UILabel()
  
  private let payButton = UIButton(type: .system)

  private let username: String
  private let rating: Double
  private let price: Int

  init(
    username: String,
    rating: Double,
    price: Int
  ) {
    self.username = username
    self.rating = rating
    self.price = price

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }

  private func setupViews() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 16
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    containerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(containerView)

    closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    closeButton.tintColor = .gray
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    containerView.addSubview(closeButton)

    titleLabel.text = "Рейтинг блогера"
    titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = .black
    containerView.addSubview(titleLabel)

    contentBackgroundView.backgroundColor = UIColor(red: 232/255, green: 234/255, blue: 236/255, alpha: 1.0)
    contentBackgroundView.layer.cornerRadius = 12
    contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(contentBackgroundView)

    bloggerLabel.text = "Блогер"
    bloggerLabel.font = .systemFont(ofSize: 13)
    bloggerLabel.textColor = .black
    bloggerLabel.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(bloggerLabel)

    bloggerUsernameLabel.text = "@\(username)"
    bloggerUsernameLabel.font = .systemFont(ofSize: 15)
    bloggerUsernameLabel.textColor = .gray
    bloggerUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(bloggerUsernameLabel)

    separator1.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    separator1.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(separator1)

    ratingLabel.text = "Рейтинг"
    ratingLabel.font = .systemFont(ofSize: 13)
    ratingLabel.textColor = .black
    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(ratingLabel)

    ratingStarsView.axis = .horizontal
    ratingStarsView.spacing = 4
    ratingStarsView.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(ratingStarsView)

    // Add rating stars
    let fullStars = Int(rating)
    for i in 0..<5 {
      let starImageView = UIImageView()
      if i < fullStars {
        starImageView.image = UIImage(named: "green_star")
      } else {
        starImageView.image = UIImage(named: "gray_star")
      }
      starImageView.contentMode = .scaleAspectFit
      ratingStarsView.addArrangedSubview(starImageView)

      NSLayoutConstraint.activate([
        starImageView.widthAnchor.constraint(equalToConstant: 16),
        starImageView.heightAnchor.constraint(equalToConstant: 16)
      ])
    }

    separator2.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    separator2.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(separator2)

    priceLabel.text = "Стоимость обзора"
    priceLabel.font = .systemFont(ofSize: 13)
    priceLabel.textColor = .black
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(priceLabel)

    priceValueLabel.text = "\(price) BYN"
    priceValueLabel.font = .systemFont(ofSize: 15)
    priceValueLabel.textColor = .gray
    priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(priceValueLabel)

    var configuration = UIButton.Configuration.filled()
    configuration.title = "Оплатить"
    configuration.baseBackgroundColor = UIColor(red: 109/255, green: 23/255, blue: 247/255, alpha: 1.0)
    configuration.baseForegroundColor = .white
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 16, weight: .medium)
      return outgoing
    }
    configuration.cornerStyle = .medium
    payButton.configuration = configuration
    payButton.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(payButton)

    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      closeButton.widthAnchor.constraint(equalToConstant: 24),
      closeButton.heightAnchor.constraint(equalToConstant: 24),

      titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),

      contentBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      contentBackgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      contentBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
      contentBackgroundView.heightAnchor.constraint(equalToConstant: 130),

      bloggerLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 16),
      bloggerLabel.centerYAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 30),

      bloggerUsernameLabel.leadingAnchor.constraint(equalTo: bloggerLabel.trailingAnchor, constant: 8),
      bloggerUsernameLabel.centerYAnchor.constraint(equalTo: bloggerLabel.centerYAnchor),

      ratingLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 16),
      ratingLabel.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 10),

      ratingStarsView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
      ratingStarsView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),

      priceLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 16),
      priceLabel.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 10),

      priceValueLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
      priceValueLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),

      separator1.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 16),
      separator1.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -16),
      separator1.topAnchor.constraint(equalTo: bloggerLabel.bottomAnchor, constant: 10),
      separator1.heightAnchor.constraint(equalToConstant: 1),

      separator2.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 16),
      separator2.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -16),
      separator2.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
      separator2.heightAnchor.constraint(equalToConstant: 1),

      payButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      payButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      payButton.topAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: 24),
      payButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
    ])
  }

  @objc private func closeTapped() {
    dismiss(animated: true)
  }
}
