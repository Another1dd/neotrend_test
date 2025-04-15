import Foundation

public struct ReviewResponse: Equatable, Sendable, Decodable {
  public var name: String
  public var createdDate: String

  public var fileName: String

  public var statistics: ReviewStatistics
  public var authorDto: ReviewAuthorDto

  public init(
    name: String,
    createdDate: String,
    fileName: String,
    statistics: ReviewStatistics,
    authorDto: ReviewAuthorDto
  ) {
    self.name = name
    self.createdDate = createdDate
    self.fileName = fileName
    self.statistics = statistics
    self.authorDto = authorDto
  }
}

public struct ReviewStatistics: Equatable, Sendable, Decodable {
  public var viewsCount: Int
  public var commentsCount: Int
  public var repostsCount: Int
  public var savesCount: Int

  public init(
    viewsCount: Int,
    commentsCount: Int,
    repostsCount: Int,
    savesCount: Int
  ) {
    self.viewsCount = viewsCount
    self.commentsCount = commentsCount
    self.repostsCount = repostsCount
    self.savesCount = savesCount
  }
}

public struct ReviewAuthorDto: Equatable, Sendable, Decodable {
  public var id: Int
  public var name: String

  public init(
    id: Int,
    name: String
  ) {
    self.id = id
    self.name = name
  }
}
