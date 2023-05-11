//
//  VCViewModel.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import Foundation

final class VCViewModel: VCViewModelProtocol {

  var model: AllCategories = []
  let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }

  func fetchAllCategoryData(completion: @escaping (() -> Void)) {
      networkService.getAllCards { result in
          switch result {
          case .success(let model):
              self.model = model
              completion()
          case .failure(let error):
            self.handleAPIError(error)
              completion()
          }
      }
  }

  func handleAPIError(_ error: Error) {
//      if let apiError = error as? APIError {
//          switch apiError {
//          case .authenticationError: break
//              displayAlert(message: "Некорректный URL")
//          case .internalServerError:
//              displayAlert(message: "Некорректный запрос")
//          case .invalidRequest:
//              displayAlert(message: "Некорректный ответ от сервера")
//          case .invalidResponse:
//              displayAlert(message: "Ошибка авторизации")
//          case .unknownError:
//              displayAlert(message: "Неизвестная ошибка")
//          case .custom(let errorMessage):
//              displayAlert(message: errorMessage)
//          }
//      } else {
//          displayAlert(message: error.localizedDescription)
//      }
  }




}
