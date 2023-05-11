//
//  ViewController.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import UIKit

final class ViewController: UIViewController {

  //MARK: - Properties

  private let viewModel: VCViewModelProtocol
  private var collectionView: UICollectionView!
  private let bankCardManagement: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Управление картами", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize1)
    button.setTitleColor(Colors.bankManagmentColor, for: .normal)
    return button
  }()

  //MARK: - Init

  init(viewModel: VCViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Colors.collectionViewBackground
    setupCollectionView()
    setConstraints()
    bind()
  }

  //MARK: - Binding

  func bind() {
    viewModel.fetchAllCategoryData {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }

  //MARK: - Setup Collection View

  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 16.0
    layout.minimumInteritemSpacing = 16.0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
    let itemWidth = (view.bounds.width - 32.0)
    layout.itemSize = CGSize(width: itemWidth, height: 220.0)

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CardCollectionViewCell.self))
    view.addSubview(collectionView)

  }

}

//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.model.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardCollectionViewCell.self), for: indexPath) as? CardCollectionViewCell else {
      return UICollectionViewCell()
    }
    let cellInfo = viewModel.model[indexPath.item]
    buttonsActionsSetup(cell: cell)
    cell.configure(model: cellInfo)
    return cell
  }
}

//MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}

//MARK: - Alert action

extension ViewController {
  func buttonsActionsSetup(cell: CardCollectionViewCell) {
    cell.buttonTappedHandler = { text in
      if let indexPath = self.collectionView.indexPath(for: cell) {
        DispatchQueue.main.async {
          self.alertAction(indexPath: indexPath.row, text: text)
        }
      }
    }
  }
}

extension ViewController {
  func alertAction(indexPath: Int, text: String) {
    let alertTitle = text
    let companyId = viewModel.model[indexPath].company.companyID

    let alertMessage = "Ид компании: \(companyId)"
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)

    present(alertController, animated: true, completion: nil)
  }
}

//MARK: - Constraints

extension ViewController {
  private func setConstraints() {
    view.addSubview(bankCardManagement)

    NSLayoutConstraint.activate([
      bankCardManagement.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      bankCardManagement.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bankCardManagement.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bankCardManagement.heightAnchor.constraint(equalToConstant: 48.0)
    ])

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: bankCardManagement.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])



  }
}


