import AVKit
import ComposableArchitecture
import UIKit
import Nuke

public class BloggerVideoViewController: UIViewController {
  @UIBindable public var store: StoreOf<BloggerVideo>

  public override var prefersStatusBarHidden: Bool {
    true
  }

  private let activityIndicator = UIActivityIndicatorView(style: .large)
  private let orderButton = UIButton(type: .system)
  private let playButton = UIButton(type: .system)
  private let pauseButton = UIButton(type: .system)
  private let avatarImageView = UIImageView()
  private let authorNameLabel = UILabel()

  private let statsStackView = UIStackView()
  private let viewsButton = UIButton(type: .system)
  private let commentsButton = UIButton(type: .system)
  private let sharesButton = UIButton(type: .system)
  private let bookmarkButton = UIButton(type: .system)

  private let nameLabel = UILabel()
  private let dateLabel = UILabel()
  private let timeLabel = UILabel()
  private let separatorLine = UIView()

  private let playerLayer = AVPlayerLayer()
  private let playerContainer = UIView()

  private var isLoadingAvatarImage = false

  public init(store: StoreOf<BloggerVideo>) {
    self.store = store

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    store.send(.onLoad)

    view.backgroundColor = .white
    navigationController?.setNavigationBarHidden(true, animated: false)

    setupActivityIndicator()
    setupPlayerContainer()
    setupOrderButton()
    setupStatsButtons()
    setupNameAndDate()
    setupAvatarImageView()

    observe { [weak self] in
      guard let self else { return }

      self.activityIndicator.isHidden = !store.isLoadingReview
      self.playButton.isHidden = store.isLoadingReview || store.videoURL == nil || store.isPlaying
      self.pauseButton.isHidden = !store.isPlaying

      if let player = store.player, self.playerLayer.player != player {
        self.playerLayer.player = player
      }

      if let avatarURL = store.avatarURL, !isLoadingAvatarImage, avatarImageView.image == nil {
        isLoadingAvatarImage = true

        ImagePipeline.shared.loadImage(with: avatarURL) { [weak self] response in
          guard let self = self else {
            return
          }

          switch response {

          case .failure:
            isLoadingAvatarImage = false
            // Add error placeholder
            break;

          case let .success(imageResponse):
            isLoadingAvatarImage = false

            self.avatarImageView.image = imageResponse.image
            self.avatarImageView.contentMode = .scaleAspectFill
          }
        }
      }
      self.authorNameLabel.text = store.authorName

      let isFooterVisible = store.isFooterVisible
      self.avatarImageView.isHidden = !isFooterVisible
      self.authorNameLabel.isHidden = !isFooterVisible
      self.nameLabel.isHidden = !isFooterVisible
      self.dateLabel.isHidden = !isFooterVisible
      self.timeLabel.isHidden = !isFooterVisible
      self.statsStackView.isHidden = !isFooterVisible
      self.orderButton.isHidden = !isFooterVisible

      self.nameLabel.text = store.name
      self.dateLabel.text = store.createdDate
      self.timeLabel.text = formatTime(store.currentTime)

      var viewsConfig = self.viewsButton.configuration
      viewsConfig?.title = self.formatCount(store.viewsCount)
      self.viewsButton.configuration = viewsConfig

      var commentsConfig = self.commentsButton.configuration
      commentsConfig?.title = self.formatCount(store.commentsCount)
      self.commentsButton.configuration = commentsConfig

      var sharesConfig = self.sharesButton.configuration
      sharesConfig?.title = self.formatCount(store.repostsCount)
      self.sharesButton.configuration = sharesConfig

      var bookmarkConfig = self.bookmarkButton.configuration
      bookmarkConfig?.title = self.formatCount(store.savesCount)
      self.bookmarkButton.configuration = bookmarkConfig
    }

    present(item: $store.scope(state: \.alert, action: \.alert)) { store in
      UIAlertController(store: store)
    }
  }

  public override func viewDidAppear(_ animated: Bool) {
    store.send(.onAppear)
  }

  public override func viewDidDisappear(_ animated: Bool) {
    store.send(.onDisappear)
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    playerLayer.frame = playerContainer.bounds
  }

  private func setupActivityIndicator() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicator)

    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    activityIndicator.startAnimating()
  }

  private func setupPlayerContainer() {
    playerContainer.translatesAutoresizingMaskIntoConstraints = false
    playerContainer.backgroundColor = .white
    view.addSubview(playerContainer)

    playerLayer.videoGravity = .resizeAspectFill
    playerContainer.layer.addSublayer(playerLayer)

    NSLayoutConstraint.activate([
      playerContainer.topAnchor.constraint(equalTo: view.topAnchor),
      playerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      playerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      playerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerTapped))
    playerContainer.addGestureRecognizer(tapGesture)
  }

  @objc private func playerTapped() {
    if store.isPlaying {
      store.send(.pauseVideoTapped)
    } else {
      store.send(.playVideoTapped)
    }

    store.send(.showFooter)
  }

  private func setupNameAndDate() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.translatesAutoresizingMaskIntoConstraints = false

    nameLabel.textColor = .white
    nameLabel.font = .systemFont(ofSize: 18, weight: .bold)

    dateLabel.textColor = .white
    dateLabel.font = .systemFont(ofSize: 13, weight: .regular)

    timeLabel.textColor = .white
    timeLabel.font = .systemFont(ofSize: 13, weight: .regular)
    timeLabel.text = "00:00"

    view.addSubview(nameLabel)
    view.addSubview(dateLabel)
    view.addSubview(timeLabel)

    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -8),
      nameLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -16),

      dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      dateLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -16),
      dateLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),

      timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      timeLabel.bottomAnchor.constraint(equalTo: statsStackView.topAnchor, constant: -16)
    ])
  }

  private func setupStatsButtons() {
    statsStackView.translatesAutoresizingMaskIntoConstraints = false
    statsStackView.axis = .horizontal
    statsStackView.distribution = .fillEqually
    statsStackView.alignment = .center
    
    view.addSubview(statsStackView)

    [viewsButton, commentsButton, sharesButton, bookmarkButton].forEach { button in
      button.tintColor = .white
      statsStackView.addArrangedSubview(button)
    }

    var viewsConfig = UIButton.Configuration.plain()
    viewsConfig.image = UIImage(named: "eye")
    viewsConfig.imagePlacement = .top
    viewsConfig.imagePadding = 8
    viewsConfig.title = "0"
    viewsConfig.baseForegroundColor = .white
    viewsConfig.titleLineBreakMode = .byTruncatingTail
    viewsConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 13, weight: .medium)
      return outgoing
    }
    viewsButton.configuration = viewsConfig

    var commentsConfig = UIButton.Configuration.plain()
    commentsConfig.image = UIImage(named: "comments")
    commentsConfig.imagePlacement = .top
    commentsConfig.imagePadding = 8
    commentsConfig.title = "0"
    commentsConfig.baseForegroundColor = .white
    commentsConfig.titleLineBreakMode = .byTruncatingTail
    commentsConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 13, weight: .medium)
      return outgoing
    }
    commentsButton.configuration = commentsConfig

    var sharesConfig = UIButton.Configuration.plain()
    sharesConfig.image = UIImage(named: "arrows")
    sharesConfig.imagePlacement = .top
    sharesConfig.imagePadding = 8
    sharesConfig.title = "0"
    sharesConfig.baseForegroundColor = .white
    sharesConfig.titleLineBreakMode = .byTruncatingTail
    sharesConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 13, weight: .medium)
      return outgoing
    }
    sharesButton.configuration = sharesConfig

    var bookmarkConfig = UIButton.Configuration.plain()
    bookmarkConfig.image = UIImage(named: "bookmark")
    bookmarkConfig.imagePlacement = .top
    bookmarkConfig.imagePadding = 8
    bookmarkConfig.title = "0"
    bookmarkConfig.baseForegroundColor = .white
    bookmarkConfig.titleLineBreakMode = .byTruncatingTail
    bookmarkConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 13, weight: .medium)
      return outgoing
    }
    bookmarkButton.configuration = bookmarkConfig

    NSLayoutConstraint.activate([
      statsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
      statsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
      statsStackView.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: -24)
    ])
  }

  private func setupOrderButton() {
    orderButton.translatesAutoresizingMaskIntoConstraints = false

    var configuration = UIButton.Configuration.filled()
    configuration.title = "Заказать обзор у блогера"
    configuration.baseForegroundColor = .white
    configuration.baseBackgroundColor = UIColor(red: 109/255, green: 23/255, blue: 247/255, alpha: 1.0) // #6d17f7
    configuration.cornerStyle = .medium
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 16, weight: .medium)
      return outgoing
    }

    orderButton.configuration = configuration
    orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    view.addSubview(orderButton)

    NSLayoutConstraint.activate([
      orderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      orderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    ])
  }

  @objc private func orderButtonTapped() {
    let vc = BloggerOrderViewController(
      username: store.authorName,
      rating:  4,
      price: 120
    )
    vc.modalPresentationStyle = .overFullScreen
    present(vc, animated: true)
  }

  private func setupAvatarImageView() {
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarImageView.contentMode = .scaleAspectFill
    avatarImageView.clipsToBounds = true
    avatarImageView.layer.cornerRadius = 20
    view.addSubview(avatarImageView)

    authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
    authorNameLabel.textColor = .white
    authorNameLabel.font = .systemFont(ofSize: 16, weight: .medium)
    view.addSubview(authorNameLabel)

    NSLayoutConstraint.activate([
      avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      avatarImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -16),
      avatarImageView.widthAnchor.constraint(equalToConstant: 40),
      avatarImageView.heightAnchor.constraint(equalToConstant: 40),

      authorNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
      authorNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
      authorNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
    ])
  }

  private func formatCount(_ count: Int) -> String {
    switch count {
    case 0..<1000:
      return "\(count)"
    case 1000..<1_000_000:
      let thousands = Double(count) / 1000.0
      return String(format: "%.1f тыс.", thousands)
        .replacingOccurrences(of: ".0", with: "")
    default:
      let millions = Double(count) / 1_000_000.0
      return String(format: "%.1f млн.", millions)
        .replacingOccurrences(of: ".0", with: "")
    }
  }

  private func formatTime(_ time: CMTime) -> String {
    let seconds = Int(CMTimeGetSeconds(time))
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
  }
}
