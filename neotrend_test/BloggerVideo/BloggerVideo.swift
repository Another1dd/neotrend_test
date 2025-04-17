import AVFoundation
import CachingPlayerItem
import ComposableArchitecture
import Foundation

@Reducer
public struct BloggerVideo: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Presents public var alert: AlertState<Action.Alert>?

    public var isLoadingReview: Bool = false
    public var isPlaying: Bool = false

    public var avatarURL: URL? = nil
    public var videoURL: URL? = nil
    public var player: AVPlayer? = nil
    public var playerLooper: AVPlayerLooper? = nil

    public init() {}
  }

  public enum Action: Sendable {
    case alert(PresentationAction<Alert>)

    case onLoad
    case onAppear
    case onDisappear

    case reviewResponse(Result<ReviewResponse, Error>)

    case requestBloggerReviewTapped
    case playVideoTapped
    case pauseVideoTapped

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

      case .onAppear:
        if let player = state.player {
          player.play()
          state.isPlaying = true
        }
        return .none

      case .onDisappear:
        state.player?.pause()
        state.isPlaying = false
        return .none

      case .requestBloggerReviewTapped:
        return .none

      case let .reviewResponse(.success(response)):
        state.isLoadingReview = false

        let playerItem = CachingPlayerItem(
          model: response
        )
        
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        state.player = queuePlayer
        state.player?.automaticallyWaitsToMinimizeStalling = false
        state.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        state.player?.play()
        state.isPlaying = true

        state.avatarURL = URL.baseURL?
          .appending(path: RestConstants.authorsPath)
          .appending(path: String(response.authorDto.id))
          .appending(path: RestConstants.avatarPath)

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
        return .none

      case .playVideoTapped:
        state.player?.play()
        state.isPlaying = true
        return .none

      case .pauseVideoTapped:
        state.player?.pause()
        state.isPlaying = false
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

extension CachingPlayerItem {
  var response: ReviewResponse? {
    passOnObject as? ReviewResponse
  }

  convenience init(model: ReviewResponse) {
    var saveFilePath = try? FileManager.default.url(for: .cachesDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: true)
    saveFilePath?.appendPathComponent(model.fileName)

    if let saveFilePath = saveFilePath, FileManager.default.fileExists(atPath: saveFilePath.path) {
      self.init(filePathURL: saveFilePath)
    } else {
      let videoURL = URL.baseURL?
        .appending(path: RestConstants.videoPath)
        .appending(queryItems: [URLQueryItem(name: RestConstants.fileName, value: model.fileName)])

      self.init(url: videoURL!, saveFilePath: saveFilePath?.path ?? model.fileName, customFileExtension: videoURL?.pathExtension)
    }

    self.passOnObject = model
  }
}
