import ComposableArchitecture

@Reducer
public struct Start: Sendable {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action: Sendable {
    case openBlogerVideoButtonTapped
  }

  public init() {}

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .openBlogerVideoButtonTapped:
        return .none
      }
    }
  }
}
