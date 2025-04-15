import ComposableArchitecture

@Reducer
public enum Root {
  case start(Start)
  case bloggerVideo(BloggerVideo)

  public static var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .start(.openBlogerVideoButtonTapped):
        state = .bloggerVideo(BloggerVideo.State())

        return .none
      case .bloggerVideo:
        return .none

      }
    }
    .ifCaseLet(\.start, action: \.start) {
      Start()
    }
    .ifCaseLet(\.bloggerVideo, action: \.bloggerVideo) {
      BloggerVideo()
    }
  }
}

extension Root.State: Equatable {}
