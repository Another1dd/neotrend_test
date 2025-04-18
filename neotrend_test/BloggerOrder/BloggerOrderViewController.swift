import ComposableArchitecture
import UIKit

class BloggerOrderViewController: KUIViewController {
  @UIBindable public var store: StoreOf<BloggerOrder>

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

  // Message input views
  private let messageContainerView = UIView()
  private let messageTextView = UITextView()
  private let sendButton = UIButton(type: .system)
  private let messageBackgroundView = UIView()
  private let balanceLabel = UILabel()
  private let messageHintLabel = UILabel()

  // Success message views
  private let successMessageView = UIView()
  private let successLabel = UILabel()
  private let okButton = UIButton(type: .system)

  public init(store: StoreOf<BloggerOrder>) {
    self.store = store

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupMessageViews()
    setupSuccessMessageView()

    observe { [weak self] in
      guard let self else { return }

      self.bloggerUsernameLabel.text = "@\(store.username)"

      self.ratingStarsView.subviews.forEach({ $0.removeFromSuperview()})
      let fullStars = Int(store.rating)
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

      priceValueLabel.text = "\(store.price) BYN"

      messageContainerView.isHidden = !store.isShowSendMessage || store.isMessageSent
      contentBackgroundView.isHidden = store.isShowSendMessage
      payButton.isHidden = store.isShowSendMessage
      successMessageView.isHidden = !store.isMessageSent

      if store.isShowSendMessage {
        titleLabel.text = store.isMessageSent ? "Отлично!" : "Отправить сообщение"

        if store.isMessageSent {
          messageContainerView.removeFromSuperview()
          successLabel.text = "Ваше сообщение @\(store.username)\nотправлено."
        } else {
          balanceLabel.text = "На вашем балансе заморожено \(store.price) р\nдо момента одобрения вами обзора,\nприсланного блогером @\(store.username).\nБлогеру отправлен запрос."
        }
      } else {
        titleLabel.text = "Рейтинг блогера"
      }
    }
  }

  private func setupViews() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 24
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    containerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(containerView)

    closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    closeButton.tintColor = .gray
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    containerView.addSubview(closeButton)

    titleLabel.text = "Рейтинг блогера"
    titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
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

    separator2.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    separator2.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(separator2)

    priceLabel.text = "Стоимость обзора"
    priceLabel.font = .systemFont(ofSize: 13)
    priceLabel.textColor = .black
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    contentBackgroundView.addSubview(priceLabel)

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
    payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
    containerView.addSubview(payButton)

    bottomConstraintForKeyboard =  view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomConstraintForKeyboard,

      closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
      closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
      closeButton.widthAnchor.constraint(equalToConstant: 24),
      closeButton.heightAnchor.constraint(equalToConstant: 24),

      titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),

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
      payButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
      payButton.heightAnchor.constraint(equalToConstant: 50),
    ])
  }

  private func setupMessageViews() {
    messageContainerView.isHidden = true
    messageContainerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(messageContainerView)

    balanceLabel.numberOfLines = 0
    balanceLabel.textAlignment = .center
    balanceLabel.font = .systemFont(ofSize: 15)
    balanceLabel.textColor = .black
    balanceLabel.translatesAutoresizingMaskIntoConstraints = false
    messageContainerView.addSubview(balanceLabel)

    messageHintLabel.text = "ВАШЕ СООБЩЕНИЕ"
    messageHintLabel.font = .systemFont(ofSize: 13)
    messageHintLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    messageHintLabel.translatesAutoresizingMaskIntoConstraints = false
    messageContainerView.addSubview(messageHintLabel)

    messageBackgroundView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    messageBackgroundView.layer.cornerRadius = 12
    messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    messageContainerView.addSubview(messageBackgroundView)

    messageTextView.font = .systemFont(ofSize: 15)
    messageTextView.textColor = .black
    messageTextView.backgroundColor = .clear
    messageTextView.translatesAutoresizingMaskIntoConstraints = false
    messageTextView.delegate = self
    messageBackgroundView.addSubview(messageTextView)

    var configuration = UIButton.Configuration.filled()
    configuration.title = "Отправить сообщение"
    configuration.baseBackgroundColor = UIColor(red: 109/255, green: 23/255, blue: 247/255, alpha: 1.0)
    configuration.baseForegroundColor = .white
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 16, weight: .medium)
      return outgoing
    }
    configuration.cornerStyle = .medium
    sendButton.configuration = configuration
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.addTarget(self, action: #selector(sendMessageTapped), for: .touchUpInside)
    messageContainerView.addSubview(sendButton)

    NSLayoutConstraint.activate([
      messageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      messageContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      messageContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
      messageContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

      balanceLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 24),
      balanceLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -24),
      balanceLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor),

      messageHintLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 24),
      messageHintLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 32),

      messageBackgroundView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 24),
      messageBackgroundView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -24),
      messageBackgroundView.topAnchor.constraint(equalTo: messageHintLabel.bottomAnchor, constant: 8),
      messageBackgroundView.heightAnchor.constraint(equalToConstant: 120),

      messageTextView.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 16),
      messageTextView.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -16),
      messageTextView.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 8),
      messageTextView.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -8),

      sendButton.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 24),
      sendButton.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -24),
      sendButton.topAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: 24),
      sendButton.heightAnchor.constraint(equalToConstant: 50),
      sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
    ])
  }

  private func setupSuccessMessageView() {
    successMessageView.isHidden = true
    successMessageView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(successMessageView)

    successLabel.numberOfLines = 0
    successLabel.textAlignment = .center
    successLabel.font = .systemFont(ofSize: 15)
    successLabel.textColor = .black
    successLabel.translatesAutoresizingMaskIntoConstraints = false
    successMessageView.addSubview(successLabel)

    var configuration = UIButton.Configuration.filled()
    configuration.title = "Понятно"
    configuration.baseBackgroundColor = UIColor(red: 109/255, green: 23/255, blue: 247/255, alpha: 1.0)
    configuration.baseForegroundColor = .white
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 16, weight: .medium)
      return outgoing
    }
    configuration.cornerStyle = .medium
    okButton.configuration = configuration
    okButton.translatesAutoresizingMaskIntoConstraints = false
    okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
    successMessageView.addSubview(okButton)

    NSLayoutConstraint.activate([
      successMessageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      successMessageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      successMessageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      successMessageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

      successLabel.leadingAnchor.constraint(equalTo: successMessageView.leadingAnchor, constant: 24),
      successLabel.trailingAnchor.constraint(equalTo: successMessageView.trailingAnchor, constant: -24),
      successLabel.topAnchor.constraint(equalTo: successMessageView.topAnchor, constant: 16),

      okButton.leadingAnchor.constraint(equalTo: successMessageView.leadingAnchor, constant: 24),
      okButton.trailingAnchor.constraint(equalTo: successMessageView.trailingAnchor, constant: -24),
      okButton.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 44),
      okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
      okButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  @objc private func closeTapped() {
    dismiss(animated: true)
  }

  @objc private func payTapped() {
    store.send(.payTapped)
  }

  @objc private func sendMessageTapped() {
    store.send(.sendMessageTapped)
  }

  @objc private func okTapped() {
    dismiss(animated: true)
  }
}

extension BloggerOrderViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    store.send(.messageChanged(textView.text))
  }
}
