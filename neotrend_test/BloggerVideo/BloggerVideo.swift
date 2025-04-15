import ComposableArchitecture

@Reducer
public struct BloggerVideo: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Presents public var alert: AlertState<Action.Alert>?
    
    public var isLoadingReview: Bool = false
    
    public init() {}
  }
  
  public enum Action: Sendable {
    case alert(PresentationAction<Alert>)
    
    case onLoad
    
    case requestBloggerReviewTapped
    
    case reviewResponse(Result<ReviewResponse, Error>)
    
    @CasePathable
    public enum Alert: Equatable, Sendable {
      case cancelTapped
      case retryTapped
    }
  }
  
  @Dependency(\.restClient) var restClient
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .alert(.presented(.cancelTapped)):
        state.alert = nil
        
        return .none
        
      case .alert(.presented(.retryTapped)):
        state.alert = nil
        state.isLoadingReview = true
        
        return .run { send in
          await send(
            .reviewResponse(
              Result {
                try await restClient.review()
              }
            )
          )
        }
        
      case .alert:
        return .none
        
      case .onLoad:
        state.isLoadingReview = true
        
        return .run { send in
          await send(
            .reviewResponse(
              Result {
                try await restClient.review()
              }
            )
          )
        }
        
      case .requestBloggerReviewTapped:
        return .none
        
      case let .reviewResponse(.success(response)):
        state.isLoadingReview = false
        
        return .none
        
      case let .reviewResponse(.failure(error)):
        state.alert = AlertState {
          TextState(error.localizedDescription)
        } actions: {
          ButtonState(role: .none, action: .retryTapped) {
            TextState("Retry")
          }
          
          ButtonState(role: .cancel, action: .cancelTapped) {
            TextState("Cancel")
          }
        }
        
        state.isLoadingReview = false
        
        return.none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}
