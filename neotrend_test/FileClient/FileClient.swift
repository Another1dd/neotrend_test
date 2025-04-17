import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct FileClient: Sendable {
  public var copy: @Sendable (URL) async -> URL = { _ in URL(filePath: "")! }

  public var file: @Sendable (String) async -> URL?
}

extension FileClient: TestDependencyKey {
  public static let testValue = Self()
}

extension DependencyValues {
  public var fileClient: FileClient {
    get { self[FileClient.self] }
    set { self[FileClient.self] = newValue }
  }
}
