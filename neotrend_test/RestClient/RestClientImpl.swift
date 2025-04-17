import Dependencies
import Foundation
import Get

extension RestClient: DependencyKey {
  public static var liveValue: RestClient {
    let impl = RestClientImpl()

    return Self(
      review: {
        try await impl.review()
      },
      download: {
        try await impl.download(fileName: $0)
      }
    )
  }
}

final actor RestClientImpl {
  private let api: APIClient

  init() {
    self.api = APIClient(baseURL: URL.baseURL) {
      $0.decoder.keyDecodingStrategy = .useDefaultKeys
    }
  }

  func review() async throws -> ReviewResponse {
    let request = Request<ReviewResponse>(path: RestConstants.reviewPath, method: .get)

    return try await api.send(request).value
  }

  func download(fileName: String) async throws -> URL {
    let request = Request(
      path: RestConstants.videoPath,
      method: .get,
      query: [(RestConstants.fileName, fileName)],
      headers: [RestConstants.accept: RestConstants.all]
    )

    return  try await api.download(for: request).value
  }
}
