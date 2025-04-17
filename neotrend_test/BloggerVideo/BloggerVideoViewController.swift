import AVKit
import ComposableArchitecture
import UIKit

public class BloggerVideoViewController: UIViewController {
  @UIBindable public var store: StoreOf<BloggerVideo>

  public override var prefersStatusBarHidden: Bool {
    true
  }

  private let activityIndicator = UIActivityIndicatorView(style: .large)

  private let playButton = UIButton(type: .system)
  private let pauseButton = UIButton(type: .system)

  private let playerLayer = AVPlayerLayer()
  private let playerContainer = UIView()

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

    observe { [weak self] in
      guard let self else { return }

      self.activityIndicator.isHidden = !store.isLoadingReview
      self.playButton.isHidden = store.isLoadingReview || store.videoURL == nil || store.isPlaying
      self.pauseButton.isHidden = !store.isPlaying
      
      if let player = store.player, self.playerLayer.player != player {
        self.playerLayer.player = player
      }
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

  
  @objc private func playButtonTapped() {
    store.send(.playVideoTapped)
  }
  
  @objc private func pauseButtonTapped() {
    store.send(.pauseVideoTapped)
  }

  @objc private func playerTapped() {
    if store.isPlaying {
      store.send(.pauseVideoTapped)
    } else {
      store.send(.playVideoTapped)
    }
  }
}
