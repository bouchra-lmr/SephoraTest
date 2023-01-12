import Foundation

enum HTTPError: Error {
  case serverError
  case decodingError
  case invalidURL
}
