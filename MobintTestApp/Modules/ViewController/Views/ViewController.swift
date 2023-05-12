//
//  ViewController.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import UIKit

final class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {

  //MARK: - Properties

  private var viewModel: VCViewModelProtocol
  private var collectionView: UICollectionView!
  private let bankCardManagement: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Управление картами", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize1)
    button.setTitleColor(Colors.bankManagmentColor, for: .normal)
    return button
  }()
  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(string: "Подгрузка компаний")
    return refreshControl
  }()

  private var loadingView: LoadingReusableView?

  var offset = 0
  private var isLoading = false

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
    displayError()
    bind()
  }

  //MARK: - Binding

  func bind() {
    viewModel.fetchAllCategoryData(offset: offset) {
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
    collectionView.register(LoadingReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(LoadingReusableView.self)")
    view.addSubview(collectionView)
    collectionView.refreshControl = refreshControl
  }
}

extension ViewController {
  @objc private func refresh(_ sender: UIRefreshControl) {
    viewModel.fetchAllCategoryData(offset: 0) {
      self.offset = 0
      DispatchQueue.main.async {
        sender.endRefreshing()
        self.collectionView.reloadData()
      }
    }
  }
}

extension ViewController {
  func displayError() {
    viewModel.errorHandler = { [weak self] errorMessage in
      self?.handleAPIError(errorMessage)
    }
  }
}

extension ViewController {
  func handleAPIError(_ errorMessage: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Окей", style: .default, handler: nil))

      self.present(alert, animated: true, completion: nil)
    }
  }
}


//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if self.isLoading {
      return CGSize.zero
    } else {
      return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionFooter {
      guard let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(LoadingReusableView.self)", for: indexPath) as? LoadingReusableView else { return UICollectionReusableView() }
      loadingView = aFooterView
      loadingView?.backgroundColor = .clear
      return aFooterView
    }
    return UICollectionReusableView()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }

  func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    if elementKind == UICollectionView.elementKindSectionFooter {
      self.loadingView?.activityIndicator.startAnimating()
    }
  }

  func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
    if elementKind == UICollectionView.elementKindSectionFooter {
      self.loadingView?.activityIndicator.stopAnimating()
    }
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    print("index", indexPath.row)
    print("vm", viewModel.model.count - 1)
    if indexPath.row == viewModel.model.count - 1 && !self.isLoading {
      loadMoreData()
    }
  }

  func loadMoreData() {
    if !self.isLoading {

      self.isLoading = true
      self.offset += 1

      viewModel.fetchMoreCategoryData(offset: offset) { success, isEmpty in
        DispatchQueue.main.async {
          self.isLoading = false
          self.loadingView?.activityIndicator.stopAnimating()

          if success {
            if isEmpty {
              self.loadingView?.isHidden = true
            } else {
              self.collectionView.reloadData()
            }
          } else {
            // Обработка ошибки
          }
        }
      }
    }
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


