import ComposableArchitecture
import UIKit

public class BloggerVideoViewController: UIViewController {
  @UIBindable public var store: StoreOf<BloggerVideo>

  public override var prefersStatusBarHidden: Bool {
    true
  }

  private let activityIndicator = UIActivityIndicatorView(style: .large)

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

    view.backgroundColor = .systemBackground
    navigationController?.setNavigationBarHidden(true, animated: false)

    setupActivityIndicator()

    observe { [weak self] in
      guard let self else { return }

      self.activityIndicator.isHidden = !store.isLoadingReview
    }

    present(item: $store.scope(state: \.alert, action: \.alert)) { store in
      UIAlertController(store: store)
    }
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
}
