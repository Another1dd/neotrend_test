import Dependencies
import Foundation
import Get

extension RestClient: DependencyKey {
  public static var liveValue: RestClient {
    let impl = RestClientImpl()

    return Self(review: {
      try await impl.review()
    })
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
    let request = Request<ReviewResponse>(path: Constants.reviewPath, method: .get)
    let response = try await api.send(request).value

    return response
  }
}
