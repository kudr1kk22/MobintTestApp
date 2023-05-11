//
//  CardCollectionViewCell.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import UIKit
import SDWebImage

final class CardCollectionViewCell: UICollectionViewCell {

  //MARK: - Properties

  private let companyNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: Constants.fontSize1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let loyatlyLevelLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: Constants.fontSize2)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let moreButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Подробнее", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize2)
    button.layer.cornerRadius = 10
    return button
  }()



  private let showHideButton: UIButton = {
    let button = UIButton()
    button.setTitle("showHideButton", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "eye_white"), for: .normal)
    return button
  }()

  private let trashButton: UIButton = {
    let button = UIButton()
    button.setTitle("trashButton", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "trash_white"), for: .normal)
    return button
  }()

  private let bankImage: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()

  private let separatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .gray
    return view
  }()

  private let bottomSeparatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .gray
    return view
  }()

  private let pointLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let cashBackLabel: UILabel = {
    let label = UILabel()
    label.text = "Кешбэк"
    label.font = UIFont.systemFont(ofSize: Constants.fontSize3)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let cashBackPersentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: Constants.fontSize2)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let levelLabel: UILabel = {
    let label = UILabel()
    label.text = "Уровень"
    label.font = UIFont.systemFont(ofSize: Constants.fontSize3)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  var buttonTappedHandler: ((String) -> Void)?


  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
    buttonsActionsSetup()
    bankImage.makeRounded()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    bankImage.makeRounded()
  }


  //MARK: - Configure

  func configure(model: AllCategory) {
    companyNameLabel.text = model.mobileAppDashboard.companyName
    loyatlyLevelLabel.text = model.customerMarkParameters.loyaltyLevel.name
    pointLabel.text = "\(model.customerMarkParameters.loyaltyLevel.markToCash)"
    cashBackPersentLabel.text = "\(model.customerMarkParameters.loyaltyLevel.cashToMark) %"
    if let imageURL = URL(string: model.mobileAppDashboard.logo) {
      bankImage.sd_setImage(with: imageURL)
      bankImage.makeRounded()
    }

    configureAppearence(model: model)

  }

  func buttonsActionsSetup() {
    moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
    trashButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
    showHideButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
  }


  //MARK: - Actions

  @objc private func moreButtonTapped(_ sender: UIButton) {
    guard let buttonText = sender.titleLabel?.text else { return }
    buttonTappedHandler?(buttonText)
  }


  //MARK: - Configure appearence

  func configureAppearence(model: AllCategory) {
    moreButton.setTitleColor(UIColor(hexString: model.mobileAppDashboard.mainColor), for: .normal)
    moreButton.backgroundColor = UIColor(hexString: model.mobileAppDashboard.backgroundColor)
    showHideButton.backgroundColor = UIColor(hexString: model.mobileAppDashboard.mainColor)
    trashButton.backgroundColor = UIColor(hexString: model.mobileAppDashboard.accentColor)
    cashBackLabel.textColor = UIColor(hexString: model.mobileAppDashboard.textColor)
    levelLabel.textColor = UIColor(hexString: model.mobileAppDashboard.textColor)
    cellUIStyle(model: model)
  }

  func cellUIStyle(model: AllCategory) {
    let backgroundColor = UIColor(hexString: model.mobileAppDashboard.cardBackgroundColor)
    contentView.backgroundColor = backgroundColor

    let cornerRadius: CGFloat = 15
    contentView.layer.cornerRadius = cornerRadius
    contentView.layer.masksToBounds = true
    let points = "\(model.customerMarkParameters.loyaltyLevel.cashToMark) баллов"
    setNSAttributedString(text: points, colorOfPoints: model.mobileAppDashboard.highlightTextColor, color: model.mobileAppDashboard.textColor)
  }

  func setNSAttributedString(text: String, colorOfPoints: String, color: String) {
    let attributedString = NSMutableAttributedString(string: text)

    let numberRange = (text as NSString).range(of: "\\d+", options: .regularExpression)
    let numberFont = UIFont.systemFont(ofSize: Constants.fontSize1)
    attributedString.addAttributes([.font: numberFont, .foregroundColor: UIColor(hexString: colorOfPoints)], range: numberRange)

    let wordRange = (text as NSString).range(of: "баллов")
    let wordFont = UIFont.systemFont(ofSize: Constants.fontSize2)
    attributedString.addAttributes([.font: wordFont, .foregroundColor: UIColor(hexString: color)], range: wordRange)

    pointLabel.attributedText = attributedString
  }
}

//MARK: - Constraints

extension CardCollectionViewCell {
  private func setupConstraints() {

    contentView.addSubview(companyNameLabel)
    contentView.addSubview(loyatlyLevelLabel)
    contentView.addSubview(moreButton)
    contentView.addSubview(showHideButton)
    contentView.addSubview(trashButton)
    contentView.addSubview(bankImage)
    contentView.addSubview(separatorView)
    contentView.addSubview(bottomSeparatorView)
    contentView.addSubview(pointLabel)
    contentView.addSubview(cashBackLabel)
    contentView.addSubview(cashBackPersentLabel)
    contentView.addSubview(levelLabel)

    NSLayoutConstraint.activate([
      companyNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.redConstant),
      companyNameLabel.centerYAnchor.constraint(equalTo: bankImage.centerYAnchor)
    ])

    NSLayoutConstraint.activate([
      bankImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.redConstant),
      bankImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.redConstant),
      bankImage.heightAnchor.constraint(equalToConstant: 48.0),
      bankImage.widthAnchor.constraint(equalTo: bankImage.heightAnchor)
    ])

    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: bankImage.bottomAnchor, constant: Constants.yellowConstant),
      separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.redConstant),
      separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.redConstant),
      separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
    ])

    NSLayoutConstraint.activate([
      pointLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.redConstant),
      pointLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.redConstant),
      pointLabel.heightAnchor.constraint(equalToConstant: 24.0)
    ])

    NSLayoutConstraint.activate([
      cashBackLabel.topAnchor.constraint(equalTo: pointLabel.bottomAnchor, constant: Constants.redConstant),
      cashBackLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.redConstant)
    ])

    NSLayoutConstraint.activate([
      levelLabel.topAnchor.constraint(equalTo: cashBackLabel.topAnchor),
      levelLabel.leadingAnchor.constraint(equalTo: cashBackLabel.trailingAnchor, constant: Constants.blueConstant),
      levelLabel.heightAnchor.constraint(equalToConstant: 12.0)
    ])

    NSLayoutConstraint.activate([
      cashBackPersentLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: Constants.yellowConstant),
      cashBackPersentLabel.leadingAnchor.constraint(equalTo: cashBackLabel.leadingAnchor),
      cashBackPersentLabel.heightAnchor.constraint(equalToConstant: 17.0)
    ])

    NSLayoutConstraint.activate([
      loyatlyLevelLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: Constants.yellowConstant),
      loyatlyLevelLabel.leadingAnchor.constraint(equalTo: levelLabel.leadingAnchor),
      loyatlyLevelLabel.trailingAnchor.constraint(equalTo: levelLabel.trailingAnchor),
      loyatlyLevelLabel.heightAnchor.constraint(equalToConstant: 17.0)
    ])

    NSLayoutConstraint.activate([
      bottomSeparatorView.topAnchor.constraint(equalTo: loyatlyLevelLabel.bottomAnchor, constant: Constants.yellowConstant),
      bottomSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.redConstant),
      bottomSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.redConstant),
      bottomSeparatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
    ])

    NSLayoutConstraint.activate([
      showHideButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.redConstant),
      showHideButton.widthAnchor.constraint(equalToConstant: 32.0),
      showHideButton.heightAnchor.constraint(equalTo: showHideButton.widthAnchor),
      showHideButton.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: Constants.redConstant)
    ])

    NSLayoutConstraint.activate([
      trashButton.leadingAnchor.constraint(equalTo: showHideButton.trailingAnchor, constant: Constants.blueConstant),
      trashButton.widthAnchor.constraint(equalTo: showHideButton.widthAnchor),
      trashButton.heightAnchor.constraint(equalTo: trashButton.widthAnchor),
      trashButton.centerYAnchor.constraint(equalTo: showHideButton.centerYAnchor)
    ])

    NSLayoutConstraint.activate([
      moreButton.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: Constants.yellowConstant),
      moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.redConstant),
      moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.redConstant),
      moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 2)
    ])


  }
}
