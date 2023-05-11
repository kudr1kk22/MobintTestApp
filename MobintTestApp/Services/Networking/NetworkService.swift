//
//  NetworkService.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import Foundation

enum APIError: Error {
    case invalidRequest
    case invalidResponse
    case authenticationError
    case internalServerError
    case unknownError
    case custom(String)
}

private enum APIBaseURL {
  static let getAllCompanies = "http://dev.bonusmoney.pro/mobileapp/getAllCompanies"
}

final class NetworkService: NetworkServiceProtocol {
  
  //MARK: - Get add cards

  func getAllCards(completion: @escaping (Result<AllCategories, Error>) -> Void) {

    let parameters: [String: Any] = [
      "offset": 0
    ]

    self.createRequest(with: URL(string: APIBaseURL.getAllCompanies), type: .POST, parameters: parameters) { request in
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let httpResponse = response as? HTTPURLResponse {
          switch httpResponse.statusCode {
          case 200:
            if let data = data {
              do {
                let result = try JSONDecoder().decode(AllCategories.self, from: data)
                completion(.success(result))
              } catch {
                completion(.failure(error))
              }
            } else {
              completion(.failure(APIError.invalidResponse))
            }
          case 400:
            if let data = data,
               let errorMessage = self.parseErrorMessage(data: data) {
              completion(.failure(APIError.custom(errorMessage)))
            } else {
              completion(.failure(APIError.invalidRequest))
            }
          case 401:
            completion(.failure(APIError.authenticationError))
          case 500:
            completion(.failure(APIError.internalServerError))
          default:
            completion(.failure(APIError.unknownError))
          }
        } else if let error = error {
          completion(.failure(error))
        } else {
          completion(.failure(APIError.invalidResponse))
        }
      }
      task.resume()
    }
  }

  func parseErrorMessage(data: Data) -> String? {
    // Ваш код для извлечения сообщения об ошибке из данных ответа сервера
    // Верните nil, если не удается извлечь сообщение об ошибке
    return nil
  }
}

//MARK: - Create Request

extension NetworkService {
  private func createRequest(with url: URL?, type: HTTPMethod, parameters: [String: Any], completion: @escaping (URLRequest) -> Void) {
    guard let apiURL = url else { return }
    var request = URLRequest(url: apiURL)
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    request.setValue("123", forHTTPHeaderField: "TOKEN")
    request.httpMethod = type.rawValue
    request.timeoutInterval = 30
    completion(request)
  }
}
