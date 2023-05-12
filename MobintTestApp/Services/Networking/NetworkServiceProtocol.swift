//
//  NetworkServiceProtocol.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import Foundation

protocol NetworkServiceProtocol {
  func getAllCards(offset: Int, completion: @escaping (Result<AllCategories, Error>) -> Void)
}
