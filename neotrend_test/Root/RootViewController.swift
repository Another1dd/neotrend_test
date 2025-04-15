import ComposableArchitecture
import UIKit

class RootViewController: UINavigationController {
  let store: StoreOf<Root>

  init(store: StoreOf<Root>) {
    self.store = store

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    print("Root loaded")
    
    observe { [weak self] in
      guard let self else { return }
      switch store.case {
      case let .start(store):
        setViewControllers([StartViewController(store: store)], animated: false)
      case let .bloggerVideo(store):
        pushViewController(BloggerVideoViewController(store: store), animated: true)
      }
    }
  }
}

