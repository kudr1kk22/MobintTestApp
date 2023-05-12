//
//  VCViewModel.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import Foundation

final class VCViewModel: VCViewModelProtocol {

  //MARK: - Properties

  var model: AllCategories = []
  let networkService: NetworkServiceProtocol
  var errorHandler: ((String) -> Void)?

  //MARK: - Init

  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }

  //MARK: - Fetch all data

  func fetchAllCategoryData(offset: Int, completion: @escaping (() -> Void)) {
    networkService.getAllCards(offset: offset) { result in
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

  //MARK: - Fetch more data

  func fetchMoreCategoryData(offset: Int, completion: @escaping ((Bool, Bool) -> Void)) {
    networkService.getAllCards(offset: offset) { result in
      switch result {
      case .success(let model):
        let isEmpty = model.isEmpty
        if !isEmpty {
          self.model.append(contentsOf: model)
        }
        completion(true, isEmpty)
      case .failure(let error):
        self.handleAPIError(error)
        completion(false, false)
      }
    }
  }


  //MARK: - Errors

  func handleAPIError(_ error: Error) {
    if let apiError = error as? APIError {
      switch apiError {
      case .authenticationError:
        errorHandler?("Некорректный URL")
      case .internalServerError:
        errorHandler?("Некорректный запрос")
      case .invalidRequest:
        errorHandler?("Некорректный ответ от сервера")
      case .invalidResponse:
        errorHandler?("Ошибка авторизации")
      case .unknownError:
        errorHandler?("Неизвестная ошибка")
      case .custom(let errorMessage):
        errorHandler?(errorMessage)
      }
    } else {
      errorHandler?(error.localizedDescription)
    }
  }
}
