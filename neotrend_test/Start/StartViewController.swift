import ComposableArchitecture
import UIKit

public class StartViewController: UIViewController {
  @UIBindable public var store: StoreOf<Start>
  
  private let openBloggerButton = UIButton(type: .system)

  public init(store: StoreOf<Start>) {
    self.store = store

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    
    setupOpenBloggerVideoButton()
  }
  
  private func setupOpenBloggerVideoButton() {
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Открыть видео блогера"
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    configuration.baseForegroundColor = .black
    configuration.baseBackgroundColor = UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0) // Light pastel blue
    openBloggerButton.configuration = configuration

    openBloggerButton.translatesAutoresizingMaskIntoConstraints = false
    openBloggerButton.layer.borderWidth = 1.0
    openBloggerButton.layer.borderColor = UIColor.systemBlue.cgColor
    openBloggerButton.layer.cornerRadius = 8.0
    openBloggerButton.addTarget(self, action: #selector(openBloggerVideoButtonTapped), for: .touchUpInside)

    view.addSubview(openBloggerButton)
    
    NSLayoutConstraint.activate([
      openBloggerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      openBloggerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  @objc private func openBloggerVideoButtonTapped() {
    store.send(.openBlogerVideoButtonTapped)
  }
}
