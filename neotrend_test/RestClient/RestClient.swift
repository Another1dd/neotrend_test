import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct RestClient: Sendable {
  public var review:
    @Sendable () async throws -> ReviewResponse
}

extension RestClient: TestDependencyKey {
  public static let testValue = Self()
}

extension DependencyValues {
  public var restClient: RestClient {
    get { self[RestClient.self] }
    set { self[RestClient.self] = newValue }
  }
}
