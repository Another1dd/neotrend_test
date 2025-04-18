import ComposableArchitecture
import Foundation

@Reducer
public struct BloggerOrder: Sendable {
  @ObservableState
  public struct State: Equatable {
    let username: String
    let rating: Double
    let price: Int
    
    var isShowSendMessage: Bool = false
    var isMessageSent: Bool = false
    
    var message: String = ""
    
    init(
      username: String,
      rating: Double,
      price: Int
    ) {
      self.username = username
      self.rating = rating
      self.price = price
    }
  }
  
  public enum Action: Sendable {
    case payTapped
    case messageChanged(String)
    case sendMessageTapped
  }
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .payTapped:
        state.isShowSendMessage = true
        
        return .none
        
      case let .messageChanged(message):
        state.message = message
        return .none
        
      case .sendMessageTapped:
        state.isMessageSent = true
        
        return .none
      }
    }
  }
}
