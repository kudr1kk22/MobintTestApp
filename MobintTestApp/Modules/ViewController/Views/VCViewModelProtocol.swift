//
//  VCViewModelProtocol.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import Foundation

protocol VCViewModelProtocol {
  var model: AllCategories { get }
  func fetchAllCategoryData(completion: @escaping (() -> Void)) 
}
