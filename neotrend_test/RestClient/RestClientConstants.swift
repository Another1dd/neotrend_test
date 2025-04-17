import Foundation

extension URL {
  public static let baseURL = URL(string: "https://neotrend.site:8082")
}

public enum RestConstants {
  // Path
  public static let avatarPath = "avatar"
  public static let authorsPath = "api/test/authors"
  public static let reviewPath = "api/test/review"
  public static let videoPath = "api/test/video"

  // Params
  public static let fileName = "fileName"
}
