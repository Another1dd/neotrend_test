import Foundation

extension URL {
  static var assetsDirectory: Self {
    let url = Self.documentsDirectory.appending(path: "assets")
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: url.path) {
      try? fileManager.createDirectory(
        at: url,
        withIntermediateDirectories: true
      )
    }

    return url
  }
}
