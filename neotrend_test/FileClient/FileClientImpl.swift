import Dependencies
import Foundation

extension FileClient: DependencyKey {
  public static var liveValue: FileClient {
    let impl = FileClientImpl()

    return Self(
      copy: { await impl.copy($0) },
      file: { await impl.file($0) }
    )
  }
}

final actor FileClientImpl {

  func copy(_ url: URL) async -> URL {
    let fileManager = FileManager.default
    let fileName = url.lastPathComponent

    let resultURL = URL.assetsDirectory.appendingPathComponent(fileName)

    if fileManager.fileExists(atPath: resultURL.path) {
      try? fileManager.removeItem(at: resultURL)
    }

//    if url.startAccessingSecurityScopedResource() {
      try? fileManager.copyItem(at: url, to: resultURL)

//      url.stopAccessingSecurityScopedResource()

      return resultURL
//    } else {
//      throw FileClientError.accessingSecurityScopedResourceFailed
//    }
  }

  func file(_ fileName: String) -> URL? {
    let fileManager = FileManager.default
    let url = URL.assetsDirectory.appendingPathComponent(fileName)

    if fileManager.fileExists(atPath: url.path) {
      return url
    } else {
      return nil
    }
  }
}
