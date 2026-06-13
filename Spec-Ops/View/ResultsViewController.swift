//
//  ResultsViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 14/5/26.
//

import UIKit

// Sections του CollectionView — enum για type safety (top-level to avoid actor isolation)
nonisolated enum ResultsSection: Hashable {
    case main
}

@MainActor class ResultsViewController: UIViewController {
    
    // MARK: - Properties
    private let query: String
    private let viewModel = ResultsViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<ResultsSection, Product>!
    private let compareFloatingButton = UIButton(type: .system)
    
    
    // MARK: - Init
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = AppColors.accent
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppColors.primaryText
        ]
        navigationController?.navigationBar.barTintColor = AppColors.background
        view.backgroundColor = AppColors.background
        title = "Results"
        setupCollectionView()
        setupDataSource()
        setupActivityIndicator()      // ← Μετά το collectionView
        activityIndicator.startAnimating()
        bindViewModel()
        viewModel.fetchProducts(query: query)
        setupCompareButton()
    }
    
    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        // Item: 50% του πλάτους του group
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        // Group: 100% πλάτος, fixed ύψος, περιέχει 2 items
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = AppColors.background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupActivityIndicator(){
        activityIndicator.color = AppColors.accent
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCompareButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Compare"
        config.image = UIImage(systemName: "arrow.left.arrow.right")
        config.imagePadding = 8
        config.baseBackgroundColor = AppColors.accent
        config.cornerStyle = .capsule
        compareFloatingButton.configuration = config
        compareFloatingButton.addTarget(self, action: #selector(compareFloatingTapped), for: .touchUpInside)
        compareFloatingButton.isHidden = true     // κρυφό μέχρι να επιλεγούν 2+
        compareFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(compareFloatingButton)
        
        NSLayoutConstraint.activate([
            compareFloatingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            compareFloatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            compareFloatingButton.heightAnchor.constraint(equalToConstant: 50),
            compareFloatingButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductCollectionCell, Product> { [weak self] cell, indexPath, product in
            cell.configure(with: product)
            cell.delegate = self
        }
        
        // Δημιουργία DataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: product
            )
        }
    }
    
    // MARK: - Bind
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.applySnapshot()
        }
        viewModel.onError = { [weak self] message in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Snapshot
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ResultsSection, Product>()
        snapshot.appendSections([ResultsSection.main])
        snapshot.appendItems(viewModel.products)
        dataSource.apply(snapshot, animatingDifferences: true)
        activityIndicator.stopAnimating()
        updateCompareFloatingButton()
    }
    private func updateCompareFloatingButton() {
        let count = CompareManager.shared.selectedProducts.count
        compareFloatingButton.isHidden = count < 2
        compareFloatingButton.configuration?.title = "Compare (\(count))"
    }
    
    @objc private func compareFloatingTapped() {
        let selected = CompareManager.shared.selectedProducts
        guard selected.count >= 2 else { return }
        
        // Περνάμε το array 'selected' αντί για την ανύπαρκτη μεταβλητή 'product'
        let compareVC = CompareViewController(products: CompareManager.shared.selectedProducts)
        navigationController?.pushViewController(compareVC, animated: true)
    }
}
extension ResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        let detailVC = DetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension ResultsViewController: ProductCellDelegate {
    func productCellDidChangeCompareSelection() {
        updateCompareFloatingButton()
    }
}

