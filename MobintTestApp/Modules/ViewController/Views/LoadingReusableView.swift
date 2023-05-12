//
//  LoadingReusableView.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 11.05.23.
//

import UIKit

final class LoadingReusableView: UICollectionReusableView {

  //MARK: - Properties

  let activityIndicator = UIActivityIndicatorView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Подгрузка компаний"
    label.font = UIFont.systemFont(ofSize: Constants.fontSize3)
    return label
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

//MARK: - Constraints

extension LoadingReusableView {
  private func setConstraints() {
    self.addSubview(activityIndicator)
    self.addSubview(titleLabel)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      activityIndicator.bottomAnchor.constraint(equalTo: self.centerYAnchor)
    ])
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}
