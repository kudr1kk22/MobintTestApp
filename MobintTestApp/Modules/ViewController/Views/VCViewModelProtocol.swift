//
//  VCViewModelProtocol.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import Foundation

protocol VCViewModelProtocol {
  var model: AllCategories { get }
  func fetchAllCategoryData(offset: Int, completion: @escaping (() -> Void))
  func fetchMoreCategoryData(offset: Int, completion: @escaping ((Bool, Bool) -> Void))
  var errorHandler: ((String) -> Void)? { get set }
}
